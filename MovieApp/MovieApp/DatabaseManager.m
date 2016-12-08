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

-(TVEventDb *)modelForTVEvent:(TVEvent *)tvEvent{
    if([tvEvent isKindOfClass:[Movie class]]){
        return [MovieDb objectInRealm:_realm forPrimaryKey:[NSNumber numberWithInteger:tvEvent.id]];
    }
    else{
        return [TVShowDb objectInRealm:_realm forPrimaryKey:[NSNumber numberWithInteger:tvEvent.id]];
    }
}
-(NSArray *)getWatchlistOfType:(MediaType)mediaType{
    
    if(mediaType==MovieType){
        RLMResults *results=[MovieDb objectsWhere:@"isInWatchlist=YES"];
        return [Movie moviesArrayFromRLMArray:results];
    }
    else{
        RLMResults *results=[TVShowDb objectsWhere:@"isInWatchlist=YES"];
        return [TVShow tvShowsArrayFromRLMArray:results];
    }
    return nil;
}

-(NSArray *)getFavoriteTVEventsOfType:(MediaType)mediaType{
    if(mediaType==MovieType){
        RLMResults *results=[MovieDb objectsWhere:@"isInFavorites=YES"];
        return [Movie moviesArrayFromRLMArray:results];
    }
    else{
        RLMResults *results=[TVShowDb objectsWhere:@"isInFavorites=YES"];
        return [TVShow tvShowsArrayFromRLMArray:results];
    }
    return nil;
}

-(void)removeAllData{
    [_realm beginWriteTransaction];
    [_realm deleteAllObjects];
    [_realm commitWriteTransaction];
}

-(void)updateData{
    //wat to do
}
-(void)addTVEventWithID:(NSInteger)tvEventId mediaType:(MediaType)mediaType toCollection:(CollectionType)collectionType{
    TVEvent *tvEvent;
    if(mediaType==MovieType){
        tvEvent=[[Movie alloc] init];
        tvEvent.id=tvEventId;
    }
    else{
        tvEvent=[[TVShow alloc] init];
        tvEvent.id=tvEventId;
    }
    NSArray *tvEvents=[NSArray arrayWithObject:tvEvent];
    [self  addTVEventsFromArray:tvEvents toCollection:collectionType];
}
-(void)addTVEvent:(TVEvent *)tvEvent toCollection:(CollectionType)collectionType{
    NSArray *tvEvents=[NSArray arrayWithObject:tvEvent];
    [self  addTVEventsFromArray:tvEvents toCollection:collectionType];
}
-(void)removeTVEvent:(TVEvent *)tvEvent fromCollection:(CollectionType)collectionType{
    if([tvEvent isKindOfClass:[Movie class]]){
        [self removeTVEventWithID:tvEvent.id mediaType:MovieType fromCollection:collectionType];
    }
    else{
        [self removeTVEventWithID:tvEvent.id mediaType:TVShowType fromCollection:collectionType];
    }
    
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
    [_realm beginWriteTransaction];
    
    [tvEventDb setValue:@"NO" forKey:[DatabaseManager keyForCollectionType:collectionType]];
    
    [_realm commitWriteTransaction];
}

-(BOOL)containsTVEventInFavorites:(TVEvent *)tvEvent{
    return [self containsTVEvent:tvEvent inCollection:CollectionTypeFavorites];
}

-(BOOL)containsTVEventInWatchlist:(TVEvent *)tvEvent{
    return [self containsTVEvent:tvEvent inCollection:CollectionTypeWatchlist];
}

-(BOOL)containsTVEventInRatings:(TVEvent *)tvEvent{
    return [self containsTVEvent:tvEvent inCollection:CollectionTypeRatings];
}


-(BOOL)containsTVEvent:(TVEvent *)tvEvent inCollection:(CollectionType)collection{
    NSString *where=[NSString stringWithFormat:@"id=%lu AND %@=YES", tvEvent.id,[DatabaseManager keyForCollectionType:collection]];
    RLMResults *results;
    if([tvEvent isKindOfClass:[Movie class]]){
        results=[MovieDb objectsWhere:where];
    }
    else{
        results=[TVShowDb objectsWhere:where];
    }
    int tmp=results.count;
    return results.count!=0;
}
-(BOOL)containsTVEventWithID:(NSInteger)tvEventID mediaType:(MediaType)mediaType inCollection:(CollectionType)collection{
    NSString *where=[NSString stringWithFormat:@"id=%d AND %@=YES", (int)tvEventID, [DatabaseManager keyForCollectionType:collection]];
    RLMResults *results;
    if(mediaType==MovieType){
        results=[MovieDb objectsWhere:where];
    }
    else{
        results=[TVShowDb objectsWhere:where];
    }
    
    return results.count;
}
-(void)removeAllITVEventsFromCollection:(CollectionType)collectionType{
    //not implemented - probably wont be needed
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
            for(TVEvent *tvEvent in tvEvents){
                RLMResults *results=[TVShowDb objectsWhere:@"id=%d", (int)tvEvent.id];
                
                if([results count]){
                    TVShowDb *existingTVShow=results[0];
                    [existingTVShow setValue:@"YES" forKey:[DatabaseManager keyForCollectionType:collection]];
                    
                }
                else{
                    TVShowDb *newTVShow = [[TVShowDb alloc] initWithTVShow:(TVShow *)tvEvent];
                    for(int i=0;i<tvEvent.genreIDs.count;i++){
                        NSInteger genreID=[(NSNumber *)tvEvent.genreIDs[i] integerValue];
                        RLMResults *results=[GenreDb objectsWhere:@"id=%d AND isMovieGenre=NO", genreID];
                        [newTVShow.genres addObjects:results];
                    }
                    [newTVShow setValue:@"YES" forKey:[DatabaseManager keyForCollectionType:collection]];
                    [_realm addOrUpdateObject:newTVShow];
                }
            }
        }
    
    [_realm commitWriteTransaction];
}
    
-(void)addTVShowSeason:(TvShowSeason *)season toTVShowWithID:(NSInteger)tvShowID{
    TVShowDb *tvShow=[TVShowDb objectInRealm:_realm forPrimaryKey:[NSNumber numberWithInteger:tvShowID]];
    RLMResults *seasonsDb=[TVShowSeasonDb objectsWhere:@"id=%d",season.id];
    
    [_realm beginWriteTransaction];
    
    if([seasonsDb count]==0){
        TVShowSeasonDb *seasonDb=[TVShowSeasonDb seasonDbWithSeason:season];
        [tvShow.seasons addObject:seasonDb];
    }
    else{
        [tvShow.seasons addObjects:seasonsDb];
    }
    
    [_realm commitWriteTransaction];
    
}
-(void)addTVShowSeasonsFromArray:(NSArray *)seasons toTVShowWithID:(NSInteger)tvShowID{
    TVShowDb *tvShow=[TVShowDb objectInRealm:_realm forPrimaryKey:[NSNumber numberWithInteger:tvShowID]];
    
    if(!tvShow || [tvShow.seasons count]>0 || [seasons count]==0){
        return;
    }

    
    [_realm beginWriteTransaction];
    
    for(TvShowSeason *season in seasons){
        RLMResults *seasonsDb=[TVShowSeasonDb objectsWhere:@"id=%d",season.id];
        if([seasonsDb count]==0){
            TVShowSeasonDb *seasonDb=[TVShowSeasonDb seasonDbWithSeason:season];
            [tvShow.seasons addObject:seasonDb];
        }
        else{
            [tvShow.seasons addObjects:seasonsDb];
        }
    }
    
    [_realm commitWriteTransaction];

}
-(void)addTVShowEpisode:(TVShowEpisode *)episode toTVShow:(TVShow *)tvShow seasoNumber:(NSInteger)seasonNumber{
    //not implemented - probably wont be needed
}
-(void)addTVShowEpisodesFromArray:(NSArray *)episodes toTVShow:(TVShow *)tvShow seasoNumber:(NSInteger)seasonNumber{
    [self addTVShowEpisodesFromArray:episodes toTVShowWithID:tvShow.id seasoNumber:seasonNumber];
}
-(void)addTVShowEpisodesFromArray:(NSArray *)episodes toTVShowWithID:(NSInteger)tvShowID seasoNumber:(NSInteger)seasonNumber{
    TVShowDb *tvShowDb=[TVShowDb objectInRealm:_realm forPrimaryKey:[NSNumber numberWithInteger:tvShowID]];
    TVShowSeasonDb *seasonDb=tvShowDb.seasons[seasonNumber];
    if(seasonDb.episodes.count>0){
        return;
    }
    [_realm beginWriteTransaction];
    
    for(TVShowEpisode *episode in episodes){
        [seasonDb.episodes addObject:[TVShowEpisodeDb episodeDbWithEpisode:episode]];
    }
    
    [_realm commitWriteTransaction];
}
-(void)addCastMember:(CastMember *)castMember toTVEvent:(TVEvent *)tvEvent{
    //not implemented - probably wont be needed
}
-(void)addCastMembersFromArray:(NSArray *)castMembers toTVEvent:(TVEvent *)tvEvent{
    TVEventDb *tvEventDb=[self modelForTVEvent:tvEvent];
    if(!tvEvent){
        @throw NSInternalInconsistencyException;
    }
    if(tvEventDb.castMembers.count>0){
        return;
    }
    
    [_realm beginWriteTransaction];
    
    for(CastMember *castMember in castMembers){
        CastMemberDb *existingMember=[CastMemberDb objectInRealm:_realm forPrimaryKey:[NSNumber numberWithInteger:castMember.id]];
        if(!existingMember){
            [tvEventDb.castMembers addObject:[CastMemberDb castMemberDbWithCastMember:castMember]];
        }
        else{
            [tvEventDb.castMembers addObject:existingMember];
        }
    }
    
    [_realm commitWriteTransaction];
    
}
-(void)addCastMembersFromArray:(NSArray *)castMembers toTVShowWithID:(NSInteger)tvShowID seasonNumber:(NSInteger)seasonNumber episodeNumber:(NSInteger)episodeNumber{
    TVShowDb *tvShowDb=[TVShowDb objectInRealm:_realm forPrimaryKey:[NSNumber numberWithInteger:tvShowID]];
    if(!tvShowDb){
        @throw NSInternalInconsistencyException;
    }
    
    TVShowEpisodeDb *episodeDb=tvShowDb.seasons[seasonNumber].episodes[episodeNumber];
    if(episodeDb.cast.count>0){
        return;
    }
    
    [_realm beginWriteTransaction];
    
    for(CastMember *castMember in castMembers){
        CastMemberDb *castMemberDb=[CastMemberDb objectInRealm:_realm forPrimaryKey:[NSNumber numberWithInteger:castMember.id]];
        if(!castMemberDb){
            castMemberDb=[CastMemberDb castMemberDbWithCastMember:castMember];
        }
        [episodeDb.cast addObject:castMemberDb];
    }
    
    [_realm commitWriteTransaction];
}

-(void)addCrewMember:(CrewMember *)crewMember{
    //not implemented - probably wont be needed
}
-(void)addCrewMembers:(NSArray *)crewMembers toTVEvent:(TVEvent *)tvEvent{
    TVEventDb *tvEventDb=[self modelForTVEvent:tvEvent];
    
    if(tvEventDb.crewMembers.count>0){
        return;
    }
    
    [_realm beginWriteTransaction];
    
    for(CrewMember *crewMember in crewMembers){
        CrewMemberDb *existingMember=[CrewMemberDb objectInRealm:_realm forPrimaryKey:[NSNumber numberWithInteger:crewMember.id]];
        if(!existingMember){
            [tvEventDb.crewMembers addObject:[CrewMemberDb crewMemberDbWithCrewMember:crewMember]];
        }
        else{
            [tvEventDb.crewMembers addObject:existingMember];
        }
    }
    
    [_realm commitWriteTransaction];
}
-(void)addUIImage:(UIImage *)image toImageDbWithID:(NSString *)imageDbID{
    ImageDb *imageDb=[ImageDb objectInRealm:_realm forPrimaryKey:imageDbID];
    if(!imageDb){
        imageDb=[[ImageDb alloc] init];
        imageDb.fullUrlPath=imageDbID;
        [_realm beginWriteTransaction];
        [_realm addObject:imageDb];
        [_realm commitWriteTransaction];
    }
    [_realm beginWriteTransaction];
    
    imageDb.imageData= UIImageJPEGRepresentation(image, 0.5);
    
    [_realm commitWriteTransaction];
}

-(UIImage *)getUIImageFromImageDbWithID:(NSString *)imageDbId{
    ImageDb *imageDb=[ImageDb objectInRealm:_realm forPrimaryKey:imageDbId];
    if(!imageDb){
        return nil;
    }
    if(imageDb.imageData){
        return  [UIImage imageWithData:imageDb.imageData scale:0.5];
    }
    return nil;
}

-(void)addImagesFromArray:(NSArray *)images toTVEvent:(TVEvent *)tvEvent{
    TVEventDb *tvEventDb=[self modelForTVEvent:tvEvent];
    
    if(tvEventDb.images.count > 0){
        return;
    }
    [_realm beginWriteTransaction];
    
    for(Image *image in images){
        [tvEventDb.images addObject:[ImageDb imageDbWithImage:image baseUrl:BaseImageUrlForWidth92 imageAsData:nil]];
    }
    
    [_realm commitWriteTransaction];
}

-(void)addPerson:(PersonDetails *)person{
    PersonDetailsDb *personDb=[PersonDetailsDb objectInRealm:_realm forPrimaryKey:[NSNumber numberWithInteger:person.id]];
    if(!personDb){
        personDb=[PersonDetailsDb personDetailsDbWithPersonDetails:person];
    }
    
    [_realm beginWriteTransaction];
    
    [_realm addOrUpdateObject:personDb];
    
    [_realm commitWriteTransaction];
}

-(void)addReview:(TVEventReview *)review{
    //not implemented - probably wont be needed
}

-(void)addReviewsFromArray:(NSArray *)reviews toMovie:(TVEvent *)movie{
    MovieDb *movieDb=[MovieDb objectInRealm:_realm forPrimaryKey:[NSNumber numberWithInteger:movie.id]];
    if(!movieDb){
        @throw NSInternalInconsistencyException;
    }
    if(movieDb.reviews.count>0){
        return;
    }
    
    [_realm beginWriteTransaction];
    
    for(TVEventReview *review in reviews){
        [movieDb.reviews addObject:[ReviewDb reviewDbWithReview:review]];
    }
    
    [_realm commitWriteTransaction];
    
}

-(TVEvent *)getTVEventWithID:(NSInteger)tvEventID mediaType:(MediaType)mediaType{
    if(mediaType==MovieType){
        return [self getMovieWithID:tvEventID];
    }
    else{
        return [self getTVShowWithID:tvEventID];
    }
}
-(Movie *)getMovieWithID:(NSInteger)movieID{
    MovieDb *movieDb=[MovieDb objectInRealm:_realm forPrimaryKey:[NSNumber numberWithInteger:movieID]];
    return [Movie movieWithMovieDb:movieDb];

}
-(TVShow *)getTVShowWithID:(NSInteger)tvShowID{
    TVShowDb *tvShowDb=[TVShowDb objectInRealm:_realm forPrimaryKey:[NSNumber numberWithInteger:tvShowID]];
    return [TVShow tvShowWithTVShowDb:tvShowDb];

}
-(NSArray *)getSeasonsForTVShow:(TVShow *)tvShow{
    TVShowDb *tvShowDb=[TVShowDb objectInRealm:_realm forPrimaryKey:[NSNumber numberWithInteger:tvShow.id]];
    if(!tvShowDb){
        @throw NSInternalInconsistencyException;
    }
    
    return [TvShowSeason seasonsArrayWithRLMArray:(RLMResults *)tvShowDb.seasons];

}
-(NSArray *)getEpisodesForTVShow:(TVShow *)tvShow seasonNumber:(NSInteger)seasonNumber{
    return [self getEpisodesForTVShowWithID:tvShow.id seasonNumber:seasonNumber];

}
-(NSArray *)getEpisodesForTVShowWithID:(NSInteger)tvShowID seasonNumber:(NSInteger)seasonNumber{
    TVShowDb *tvShowDb=[TVShowDb objectInRealm:_realm forPrimaryKey:[NSNumber numberWithInteger:tvShowID]];
    TVShowSeasonDb *seasonDb=tvShowDb.seasons[seasonNumber];
    
    return [TVShowEpisode episodesArrayWithRLMArray:(RLMResults *)seasonDb.episodes];
    
}
-(NSArray *)getMoviesOfCollection:(CollectionType)collection{
    NSString *where=[NSString stringWithFormat:@"%@=YES", [DatabaseManager keyForCollectionType:collection]];
    RLMResults *results=[MovieDb objectsWhere:where];
    
    return [Movie moviesArrayFromRLMArray:results];

}
-(NSArray *)getTVShowsOfCollection:(CollectionType)collection{
    NSString *where=[NSString stringWithFormat:@"%@=YES", [DatabaseManager keyForCollectionType:collection]];
    RLMResults *results=[TVShowDb objectsWhere:where];  

    return [TVShow tvShowsArrayFromRLMArray:results];

}
-(NSArray *)getCastMembersForTVEvent:(TVEvent *)tvEvent{
    TVEventDb *tvEventDb=[self modelForTVEvent:tvEvent];
    if(!tvEventDb){
        @throw NSInternalInconsistencyException;
    }
    return [CastMember castMembersArrayWithRLMArray:(RLMResults *)tvEventDb.castMembers];

}
-(NSArray *)getCrewMembersForTVEvent:(TVEvent *)tvEvent{
    TVEventDb *tvEventDb=[self modelForTVEvent:tvEvent];
    if(!tvEventDb){
        @throw NSInternalInconsistencyException;
    }
    return [CrewMember crewMembersArrayWithRLMArray:(RLMResults *)tvEventDb.crewMembers];

}
-(NSArray *)getImagesForTVEvent:(TVEvent *)tvEvent{
    TVEventDb *tvEventDb=[self modelForTVEvent:tvEvent];
    if(!tvEventDb){
        @throw NSInternalInconsistencyException;
    }
    return [Image imagesArrayFromRLMArray:(RLMResults *)tvEventDb.images];

}
-(NSArray *)getReviewsForTVEvent:(TVEvent *)movie{
    MovieDb *movieDb=[MovieDb objectInRealm:_realm forPrimaryKey:[NSNumber numberWithInteger:movie.id]];
    if(!movieDb){
        @throw NSInternalInconsistencyException;
    }
    return [TVEventReview reviewsArrayWithRLMArray:(RLMResults *)movieDb.reviews];

}

-(NSArray *)getCastMembersForTVShowWithID:(NSInteger)tvShowID easonNumber:(NSInteger)seasonNumber episodeNumber:(NSInteger)episodeNumber{
    TVShowDb *tvShowDb=[TVShowDb objectInRealm:_realm forPrimaryKey:[NSNumber numberWithInteger:tvShowID]];
    if(!tvShowDb){
        @throw NSInternalInconsistencyException;
    }
    
    TVShowEpisodeDb *episodeDb=tvShowDb.seasons[seasonNumber].episodes[episodeNumber];
    
    return [CastMember castMembersArrayWithRLMArray:(RLMResults *)episodeDb.cast];
}


-(PersonDetails *)getPersonDetailsForID:(NSInteger)personID{
    PersonDetailsDb *personDetailsDb=[PersonDetailsDb objectInRealm:_realm forPrimaryKey:[NSNumber numberWithInteger:personID]];
    return [PersonDetails personDetailsWithPersonDetailsDb:personDetailsDb];
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
