#import "VirtualDataStorage.h"
#import "Movie.h"
#import "TVShowEpisode.h"
#import "CustomQueue.h"
#import "LocalNotificationHandler.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
#import "LocalNotificationManager.h"
#else
#import "LocalNotificationManagerOldVersion.h"
#endif

@interface  VirtualDataStorage (){
    NSMutableArray *_favoriteMovies;
    NSMutableArray *_watchListMovies;
    NSMutableArray *_favoriteTVShows;
    NSMutableArray *_watchListTVShows;
    CustomQueue *_mainTVShowQueue;
    NSTimer *_timer;
    
    BOOL _noMoreFavoriteTVShows;
    BOOL _noMoreFavoriteMovies;
    BOOL _noMoreWatchlistTVShows;
    BOOL _noMoreWatchlistMovies;
    
    NSUInteger _favoriteTVShowsPagesLoaded;
    NSUInteger _favoriteMoviesPagesLoaded;
    NSUInteger _watchlistTVShowsPagesLoaded;
    NSUInteger _watchlistMoviesPagesLoaded;


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
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000

        _localNotificationManager=[LocalNotificationManager sharedNotificationManager];
#else
        _localNotificationManager=[LocalNotificationManagerOldVersion sharedNotificationManager];
#endif
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
    if(!_noMoreFavoriteMovies){
        [[DataProviderService sharedDataProviderService] getFavoriteTVEventsOfType:MovieType pageNumber:_favoriteMoviesPagesLoaded+1 returnTo:self];
    }
    if(!_noMoreFavoriteTVShows){
        [[DataProviderService sharedDataProviderService] getFavoriteTVEventsOfType:TVShowType pageNumber:_favoriteTVShowsPagesLoaded+1 returnTo:self];
    }
    if(!_noMoreWatchlistMovies){
        [[DataProviderService sharedDataProviderService] getWatchlistOfType:MovieType pageNumber:_watchlistMoviesPagesLoaded+1 returnTo:self];
    }
    if(!_noMoreWatchlistTVShows){
        [[DataProviderService sharedDataProviderService] getWatchlistOfType:TVShowType pageNumber:_watchlistTVShowsPagesLoaded+1 returnTo:self];
    }

}

-(void)removeAllData{
    responseCounter=0;
    _favoriteTVShowsPagesLoaded=0;
    _favoriteMoviesPagesLoaded=0;
    _watchlistTVShowsPagesLoaded=0;
    _watchlistMoviesPagesLoaded=0;
    _noMoreFavoriteTVShows=NO;
    _noMoreFavoriteMovies=NO;
    _noMoreWatchlistTVShows=NO;
    _noMoreWatchlistMovies=NO;
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
                episode.name=@"Not found";
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
                if([customItemsArray count]<20){
                    _noMoreFavoriteMovies=YES;
                }
                else{
                    _favoriteMoviesPagesLoaded++;
                }
            }
            else{
                [_favoriteTVShows addObjectsFromArray:customItemsArray];
                if([customItemsArray count]<20){
                    _noMoreFavoriteTVShows=YES;
                }
                else{
                    _favoriteTVShowsPagesLoaded++;
                }
            }
            break;
        case SideMenuOptionWatchlist:
            if(mediaType==MovieType){
                [_watchListMovies addObjectsFromArray:customItemsArray];
                if([customItemsArray count]<20){
                    _noMoreWatchlistMovies=YES;
                }
                else{
                    _watchlistMoviesPagesLoaded++;
                }
            }
            else{
                [_watchListTVShows addObjectsFromArray:customItemsArray];
                if([customItemsArray count]<20){
                    _noMoreWatchlistTVShows=YES;
                }
                else{
                    _watchlistTVShowsPagesLoaded++;
                }
            }
            break;
        default:
            break;
    }
    if(_noMoreWatchlistTVShows && _noMoreWatchlistMovies && _noMoreFavoriteTVShows && _noMoreFavoriteMovies){
        [[NSNotificationCenter defaultCenter] postNotificationName:DataStorageReadyNotificationName object:self];
    }
    else if(responseCounter>=4){
        [self updateData];
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
    if([_mainTVShowQueue count]==0 || ![[NSUserDefaults standardUserDefaults] boolForKey:TVShowsNotificationsEnabledNSUserDefaultsKey]){
        [_timer invalidate];
        _timer=nil;
        return;
    }
    TVEvent *currentTVEvent=[_mainTVShowQueue dequeue];
    [[DataProviderService sharedDataProviderService] getAllEpisodesForTVShowWithID:currentTVEvent.id numberOfSeasons:0 returnTo:self];
    
}
-(void)removeTVEventWithID:(NSInteger)tvEventID mediaType:(MediaType)mediatype fromCollection:(SideMenuOption)collectionType{
    TVEvent *eventToRemove=nil;
    switch (collectionType) {
        case SideMenuOptionFavorites:
            if(mediatype==MovieType){
                for(TVEvent *tvEvent in _favoriteMovies){
                    if(tvEvent.id==tvEventID){
                        eventToRemove=tvEvent;
                    }
                }
                if(eventToRemove){
                    [_favoriteMovies removeObject:eventToRemove];
                }
            }
            else{
                for(TVEvent *tvEvent in _favoriteTVShows){
                    if(tvEvent.id==tvEventID){
                        eventToRemove=tvEvent;
                    }
                }
                if(eventToRemove){
                    [_favoriteTVShows removeObject:eventToRemove];
                }
            }
            break;
        case SideMenuOptionWatchlist:
            if(mediatype==MovieType){
                for(TVEvent *tvEvent in _watchListMovies){
                    if(tvEvent.id==tvEventID){
                        eventToRemove=tvEvent;
                    }
                }
                if(eventToRemove){
                    [_watchListMovies removeObject:eventToRemove];
                }
            }
            else{
                for(TVEvent *tvEvent in _watchListTVShows){
                    if(tvEvent.id==tvEventID){
                        eventToRemove=tvEvent;
                    }
                }
                if(eventToRemove){
                    [_watchListTVShows removeObject:eventToRemove];
                }
            }
            break;
        default:
            break;
    }
}

-(void)addTVEvent:(TVEvent *)tvEvent toCollection:(SideMenuOption)collectionType{
    if(collectionType==SideMenuOptionFavorites && ![self containsTVEventInFavorites:tvEvent]){
        if([tvEvent isKindOfClass:[Movie class]]){
            [_favoriteMovies addObject:tvEvent];
        }
        else{
            [_favoriteTVShows addObject:tvEvent];

           
        }
    }
    else if(collectionType==SideMenuOptionWatchlist && ![self containsTVEventInWatchlist:tvEvent]){
        if([tvEvent isKindOfClass:[Movie class]]){
             [_watchListMovies addObject:tvEvent];
        }
        else{
            [_watchListTVShows addObject:tvEvent];
        }
    }
}

@end
