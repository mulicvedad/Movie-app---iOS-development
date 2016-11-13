#import "VirtualDataStorage.h"
#import "Movie.h"
#import "LocalNotificationManager.h"
#import "TVShowEpisode.h"
#import "CustomQueue.h"
#import "LocalNotificationHandler.h"
#import "LocalNotificationManagerOldVersion.h"

@interface  VirtualDataStorage (){
    NSMutableArray *_favoriteMovies;
    NSMutableArray *_watchListMovies;
    NSMutableArray *_favoriteTVShows;
    NSMutableArray *_watchListTVShows;
    CustomQueue *_mainTVShowQueue;
    NSTimer *_timer;
}
@end
static VirtualDataStorage *sharedDataStorage;
static NSUInteger responseCounter;
static CGFloat TimerInterval=10.0f;
static id<LocalNotificationHandler> _localNotificationManager;

@implementation VirtualDataStorage

+(VirtualDataStorage *)sharedVirtualDataStorage{
    if(!sharedDataStorage){
        sharedDataStorage=[[VirtualDataStorage alloc]init];
        [sharedDataStorage configure];
        /*if([[NSProcessInfo processInfo] operatingSystemVersion].majorVersion>=10){
            _localNotificationManager=[LocalNotificationManager sharedNotificationManager];
        }
        else{*/
        _localNotificationManager=[LocalNotificationManagerOldVersion sharedNotificationManager];
        //}
    }
    return sharedDataStorage;
}
-(void)configure{
    _favoriteMovies=[[NSMutableArray alloc] init];
    _favoriteTVShows=[[NSMutableArray alloc] init];

    _watchListMovies=[[NSMutableArray alloc] init];
    _watchListTVShows=[[NSMutableArray alloc] init];

}
-(void)updateData{
    [[DataProviderService sharedDataProviderService] getFavoriteTVEventsOfType:MovieType pageNumber:1 returnTo:self];
    [[DataProviderService sharedDataProviderService] getFavoriteTVEventsOfType:TVShowType pageNumber:1 returnTo:self];

    [[DataProviderService sharedDataProviderService] getWatchlistOfType:MovieType pageNumber:1 returnTo:self];
    [[DataProviderService sharedDataProviderService] getWatchlistOfType:TVShowType pageNumber:1 returnTo:self];

}

-(void)removeAllData{
    [_favoriteMovies removeAllObjects];
    [_favoriteTVShows removeAllObjects];
    [_watchListMovies removeAllObjects];
    [_watchListTVShows removeAllObjects];

}

-(NSArray *)getFavoriteTVEventsOfType:(MediaType)mediaType{
    return mediaType==MovieType ? _favoriteMovies : _favoriteTVShows;
}
-(NSArray *)getWatchlistOfType:(MediaType)mediaType{
    return mediaType==MovieType ? _watchListMovies : _watchListTVShows;

}

-(void)updateReceiverWithNewData:(NSArray *)customItemsArray info:(NSDictionary *)info{
    if([[info objectForKey:TypeDictionaryKey] isEqualToString:EpisodesDictionaryValue]){
        NSUInteger tvShowID=[(NSNumber *)[info objectForKey:TVEventIDDictionaryKey] integerValue];
        NSString *tvShowTitle=[self titleForTVEventWithID:tvShowID mediaType:TVShowType];
        for(int i=0;i<[customItemsArray count];i++){
            TVShowEpisode *episode=customItemsArray[i];
            if(episode.name){
                episode.name=[[tvShowTitle stringByAppendingString:@": "]stringByAppendingString:episode.name];
            }
            else{
                episode.name=@"some name";
            }
        }
        
        [_localNotificationManager addNotificationAboutEpisodes:customItemsArray];
        return;
    }
    responseCounter++;
    if(!customItemsArray || [customItemsArray count]==0){
        if(responseCounter%6==0){
            [[NSNotificationCenter defaultCenter] postNotificationName:DataStorageReadyNotificationName object:self];
        }
        return;
    }
    NSNumber *optionNumber=[info objectForKey:SideMenuOptionDictionaryKey];
    SideMenuOption currentOption=(SideMenuOption)[optionNumber integerValue];
    MediaType mediaType;
    if([customItemsArray[0] isKindOfClass:[Movie class]]){
        mediaType=MovieType;
    }
    else{
        mediaType=TVShowType;
    }
    switch (currentOption) {
        case SideMenuOptionFavorites:
            if(mediaType==MovieType){
                [_favoriteMovies addObjectsFromArray:customItemsArray];
            }
            else{
                [_favoriteTVShows addObjectsFromArray:customItemsArray];
            }
            break;
        case SideMenuOptionWatchlist:
            if(mediaType==MovieType){
                [_watchListMovies addObjectsFromArray:customItemsArray];
            }
            else{
                [_watchListTVShows addObjectsFromArray:customItemsArray];
            }
            break;
        default:
            break;
    }
    if(responseCounter%4==0){
        [[NSNotificationCenter defaultCenter] postNotificationName:DataStorageReadyNotificationName object:self];
        [self beginEpisodesFetching];
    }
}

-(BOOL)containsTVEventInFavorites:(TVEvent *)tvEvent{
    if([tvEvent isKindOfClass:[Movie class]]){
        for(TVEvent *event in _favoriteMovies){
            if(event.id==tvEvent.id){
                return YES;
            }
        }
    }
    else{
        for(TVEvent *event in _favoriteTVShows){
            if(event.id==tvEvent.id){
                return YES;
            }
        }
    }
    return NO;
    
}
-(BOOL)containsTVEventInWatchlist:(TVEvent *)tvEvent{
    if([tvEvent isKindOfClass:[Movie class]]){
        for(TVEvent *event in _watchListMovies){
            if(event.id==tvEvent.id){
                return YES;
            }
        }
    }
    else{
        for(TVEvent *event in _watchListTVShows){
            if(event.id==tvEvent.id){
                return YES;
            }
        }
    }
    return NO;
    
}

-(NSString *)titleForTVEventWithID:(NSUInteger)tvEventID mediaType:(MediaType)mediaType{
    for(TVEvent *tvEvent in mediaType==MovieType ? _watchListMovies : _watchListTVShows){
        if(tvEvent.id==tvEventID){
            return tvEvent.title;
        }
    }
    return @"";
}

-(void)beginEpisodesFetching{
    _mainTVShowQueue=[CustomQueue queueWithArray:_watchListTVShows];
    _timer = [NSTimer scheduledTimerWithTimeInterval:TimerInterval
                                              target:self
                                            selector:@selector(fetchNextSetOfEpisodes)
                                            userInfo:nil repeats:YES];
}

-(void)fetchNextSetOfEpisodes{
    if([_mainTVShowQueue count]==0){
        [_timer invalidate];
        _timer=nil;
    }
    TVEvent *currentTVEvent=[_mainTVShowQueue dequeue];
    [[DataProviderService sharedDataProviderService] getAllEpisodesForTVShowWithID:currentTVEvent.id numberOfSeasons:0 returnTo:self];
    
}

@end
