#import "DatabaseManager.h"
#import "MovieDetails.h"

@interface DatabaseManager (){
    RLMRealm *_realm;
}

@end

static DatabaseManager *_uniqueInstance;

@implementation DatabaseManager
+(instancetype)sharedDatabaseManager{
    if(!_uniqueInstance){
        _uniqueInstance=[[DatabaseManager alloc] init];
        [_uniqueInstance configure];
        
    }
    return _uniqueInstance;
}
-(instancetype)init{
    if(!_uniqueInstance){
        self=[super init];
        return self;        
    }
    return _uniqueInstance;
}
-(void)configure{
    _realm=[RLMRealm defaultRealm];
}
-(NSArray *)getWatchlistOfType:(MediaType)mediaType{
    return nil;
}

-(NSArray *)getFavoriteTVEventsOfType:(MediaType)mediaType{
    return nil;
}

-(void)removeAllData{
    
}

-(void)updateData{
    
}

-(void)addTVEvent:(TVEvent *)tvEvent toCollection:(CollectionType)collectionType{
    
}

-(void)removeTVEventWithID:(NSInteger)tvEventID mediaType:(MediaType)mediatype fromCollection:(CollectionType)collectionType{
    TVEventDb *tvEventDb;
    if(mediatype==MovieType){
        tvEventDb=[MovieDb objectForPrimaryKey:[NSNumber numberWithInteger:tvEventID]];
    }
    else{
        tvEventDb=[TVShowDb objectForPrimaryKey:[NSNumber numberWithInteger:tvEventID]];
    }
    if(!tvEventDb){
        @throw NSInternalInconsistencyException;
    }
    [tvEventDb setValue:@"NO" forKey:[DatabaseManager keyForCollectionType:collectionType]];
}

-(BOOL)containsTVEventInFavorites:(TVEvent *)tvEvent{
    return NO;
}

-(BOOL)containsTVEventInWatchlist:(TVEvent *)tvEvent{
    return NO;
}

-(void)removeAllITVEventsFromCollection:(CollectionType)collectionType{
    
}
-(void)addTVEventsFromArray:(NSArray *)tvEvents toCollection:(CollectionType)collection{
    
    if(!tvEvents || [tvEvents count]==0){
        return;
    }
    
    [_realm beginWriteTransaction];
    
   
        if([tvEvents[0] isKindOfClass:[Movie class]]){
            
            for(TVEvent *tvEvent in tvEvents){
                
                MovieDb *existingMovie=[MovieDb objectForPrimaryKey:[NSNumber numberWithUnsignedInteger:tvEvent.id]];
                
                if(existingMovie){
                    [existingMovie setValue:@"YES" forKey:[DatabaseManager keyForCollectionType:collection]];
                    
                }
                else{
                    MovieDb *newMovie = [[MovieDb alloc] initWithMovie:(Movie *)tvEvent];
                    for(int i=0;i<tvEvent.genreIDs.count;i++){
                        NSInteger genreID=[(NSNumber *)tvEvent.genreIDs[i] integerValue];
                        RLMResults *results=[GenreDb objectsWhere:@"id=%d AND isMovieGenre=YES", genreID];
                        [newMovie.genres addObjects:results];
                    }
                    [newMovie setValue:@"YES" forKey:[DatabaseManager keyForCollectionType:collection]];
                    [_realm addOrUpdateObject:newMovie];
                }
            }
        }
        else{
            //MISSING LEL
        }
    
    [_realm commitWriteTransaction];
}
    
-(void)addTVShowSeason:(TvShowSeason *)season{
    
}
-(void)addTVShowSeasonsFromArray:(NSArray *)seasons{
    
}
-(void)addTVShowEpisode:(TVShowEpisode *)episode{
    
}
-(void)addTVShowEpisodesFromArray:(NSArray *)episode{
    
}
-(void)addCastMember:(CastMember *)castMember{
    
}
-(void)addCastMembersFromArray:(NSArray *)castMembers{
    
}
-(void)addCrewMember:(CrewMember *)crewMember{
    
}
-(void)addCrewMembers:(NSArray *)crewMembers{
    
}
-(void)addImage:(Image *)image{
    
}
-(void)addImagesFromArray:(NSArray *)images{
    
}
-(void)addPerson:(PersonDetails *)person{
    
}
-(void)addReview:(TVEventReview *)review{
    
}
-(void)addReviewsFromArray:(TVEventReview *)reviews{
}
-(TVEvent *)getTVEventWithID:(NSInteger)tvEventID mediaType:(MediaType)mediaType{
    return nil;
}
-(Movie *)getMovieWithID:(NSInteger)movieID{
    return nil;

}
-(TVShow *)getTVShowWithID:(NSInteger)tvShowID{
    return nil;

}
-(NSArray *)getSeasonsForTVShow:(TVShow *)tvShow{
    return nil;

}
-(NSArray *)getEpisodesForTVShow:(TVShow *)tvShow seasonNumber:(NSInteger)seasonNumber{
    return nil;

}
-(NSArray *)getMoviesOfCollection:(CollectionType)collection{
    NSString *where=[NSString stringWithFormat:@"%@=YES", [DatabaseManager keyForCollectionType:collection]];
    RLMResults *results=[MovieDb objectsWhere:where];
    
    return [Movie moviesArrayFromRLMArray:results];

}
-(NSArray *)getTVShowsOfCollection:(CollectionType)collection{
    NSString *where=[NSString stringWithFormat:@"%@=YES", [DatabaseManager keyForCollectionType:collection]];
    RLMResults *results=[TVShowDb objectsWhere:where];    /*switch (collection) {
        case CollectionTypeLatest:
            results=[TVShowDb objectsWhere:@"isInLatest=YES"];
            break;
        case CollectionTypePopular:
            results=[TVShowDb objectsWhere:@"isInPopular=YES"];
            break;
        case CollectionTypeHighestRated:
            results=[TVShowDb objectsWhere:@"isInRated=YES"];
            break;
        case CollectionTypeOnTheAir:
            results=[TVShowDb objectsWhere:@"isOnTheAir=YES"];
            break;
        case CollectionTypeAiringToday:
            results=[TVShowDb objectsWhere:@"isAiringToday=YES"];
            break;
        case CollectionTypeFavorites:
            results=[TVShowDb objectsWhere:@"isInFavorites=YES"];
            break;
        case CollectionTypeWatchlist:
            results=[TVShowDb objectsWhere:@"isInWatchlist=YES"];
            break;
        case CollectionTypeRatings:
            results=[TVShowDb objectsWhere:@"isInRatings=YES"];
            break;
        default:
            @throw NSInvalidArgumentException;
            break;
    }*/
    int count=results.count;
    return [TVShow tvShowsArrayFromRLMArray:results];

}
-(NSArray *)getCastMembersForTVEvent:(TVEvent *)tvEvent{
    return nil;

}
-(NSArray *)getCrewMembersForTVEvent:(TVEvent *)tvEvent{
    return nil;

}
-(NSArray *)getImagesForTVEvent:(TVEvent *)tvEvent{
    return nil;

}
-(NSArray *)getReviewsForTVEvent:(TVEvent *)tvEvent{
    return nil;

}


-(void)updateTVEvent:(NSInteger)tvEventID withTVEventDetails:(TVEventDetails *)tvEventDetails{
    TVEventDb *tvEvent;
    if([tvEventDetails isKindOfClass:[MovieDetails class]]){
        tvEvent=[MovieDb objectInRealm:[RLMRealm defaultRealm] forPrimaryKey:[NSNumber numberWithInteger:tvEventID]];

    }
    else{
        tvEvent=[TVShowDb objectInRealm:[RLMRealm defaultRealm] forPrimaryKey:[NSNumber numberWithInteger:tvEventID]];

    }
    if(!tvEvent){
        @throw NSInternalInconsistencyException;
    }
    [_realm beginWriteTransaction];
    
    tvEvent.title=tvEventDetails.title;
    tvEvent.originalTitle=tvEventDetails.title;
    tvEvent.releaseDate=tvEventDetails.releaseDate;
    tvEvent.backdropPath=tvEventDetails.backdropPath;
    tvEvent.posterPath=tvEventDetails.posterPath;
    tvEvent.overview=tvEventDetails.overview;
    tvEvent.voteAverage=tvEventDetails.voteAverage;
    tvEvent.duration=tvEventDetails.duration;
    
    [_realm commitWriteTransaction];
    
    
}

+(NSString *)keyForCollectionType:(CollectionType)collection{
    switch (collection) {
        case CollectionTypeLatest:
            return @"isInLatest";
        case CollectionTypePopular:
            return @"isInPopular";
        case CollectionTypeHighestRated:
            return @"isInHighestRated";
        case CollectionTypeOnTheAir:
            return @"isOnTheAir";
        case CollectionTypeAiringToday:
            return @"isAiringToday";
        case CollectionTypeFavorites:
            return @"isInFavorites";
        case CollectionTypeWatchlist:
            return @"isInWatchlist";
            break;
        case CollectionTypeRatings:
            return @"isInRatings";
            break;
        default:
            @throw NSInvalidArgumentException;
            break;
    }

}
@end
