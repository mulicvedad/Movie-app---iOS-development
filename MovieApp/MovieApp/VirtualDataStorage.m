#import "VirtualDataStorage.h"
#import "Movie.h"

@interface  VirtualDataStorage (){
    NSMutableArray *_favoriteMovies;
    NSMutableArray *_watchListMovies;
    NSMutableArray *_ratedMovies;
    NSMutableArray *_favoriteTVShows;
    NSMutableArray *_watchListTVShows;
    NSMutableArray *_ratedTVShows;
}
@end
static VirtualDataStorage *sharedDataStorage;
static NSUInteger responseCounter;
@implementation VirtualDataStorage

+(VirtualDataStorage *)sharedVirtualDataStorage{
    if(!sharedDataStorage){
        sharedDataStorage=[[VirtualDataStorage alloc]init];
        [sharedDataStorage configure];
    }
    return sharedDataStorage;
}
-(void)configure{
    _favoriteMovies=[[NSMutableArray alloc] init];
    _favoriteTVShows=[[NSMutableArray alloc] init];

    _watchListMovies=[[NSMutableArray alloc] init];
    _watchListTVShows=[[NSMutableArray alloc] init];
    
    _ratedMovies=[[NSMutableArray alloc] init];
    _ratedTVShows=[[NSMutableArray alloc] init];

}
-(void)updateData{
    [[DataProviderService sharedDataProviderService] getFavoriteTVEventsOfType:MovieType pageNumber:1 returnTo:self];
    [[DataProviderService sharedDataProviderService] getFavoriteTVEventsOfType:TVShowType pageNumber:1 returnTo:self];

    [[DataProviderService sharedDataProviderService] getWatchlistOfType:MovieType pageNumber:1 returnTo:self];
    [[DataProviderService sharedDataProviderService] getWatchlistOfType:TVShowType pageNumber:1 returnTo:self];

    [[DataProviderService sharedDataProviderService] getRatedTVEventsOfType:MovieType pageNumber:1 returnTo:self];
    [[DataProviderService sharedDataProviderService] getRatedTVEventsOfType:TVShowType pageNumber:1 returnTo:self];
}

-(void)removeAllData{
    [_favoriteMovies removeAllObjects];
    [_favoriteTVShows removeAllObjects];
    [_watchListMovies removeAllObjects];
    [_watchListTVShows removeAllObjects];
    [_ratedMovies removeAllObjects];
    [_ratedTVShows removeAllObjects];
}

-(NSArray *)getFavoriteTVEventsOfType:(MediaType)mediaType{
    return mediaType==MovieType ? _favoriteMovies : _favoriteTVShows;
}
-(NSArray *)getWatchlistOfType:(MediaType)mediaType{
    return mediaType==MovieType ? _watchListMovies : _watchListTVShows;

}
-(NSArray *)getRatedTVEventsOfType:(MediaType)mediaType{
    return mediaType==MovieType ? _ratedMovies : _ratedTVShows;
}
-(void)updateReceiverWithNewData:(NSArray *)customItemsArray info:(NSDictionary *)info{
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
        case SideMenuOptionRatings:
            if(mediaType==MovieType){
                [_ratedMovies addObjectsFromArray:customItemsArray];
            }
            else{
                [_ratedTVShows addObjectsFromArray:customItemsArray];
            }
            break;
        default:
            break;
    }
    if(responseCounter%6==0){
        [[NSNotificationCenter defaultCenter] postNotificationName:DataStorageReadyNotificationName object:self];
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
-(BOOL)containsTVEventInRatedEvents:(TVEvent *)tvEvent{
    if([tvEvent isKindOfClass:[Movie class]]){
        for(TVEvent *event in _ratedMovies){
            if(event.id==tvEvent.id){
                return YES;
            }
        }
    }
    else{
        for(TVEvent *event in _ratedTVShows){
            if(event.id==tvEvent.id){
                return YES;
            }
        }
    }
    return NO;
    
}
@end
