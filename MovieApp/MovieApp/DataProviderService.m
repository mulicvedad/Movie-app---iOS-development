#import "DataProviderService.h"
#import "Movie.h"
#import "ItemsArrayReceiver.h"
#import <RestKit.h>
#import "TVEventsViewController.h"
#import "TVShow.h"
#import "Genre.h"
#import "CrewMember.h"
#import "CastMember.h"
#import "MovieDetails.h"
#import "TVShowDetails.h"
#import "TvShowSeason.h"
#import "Image.h"
#import "TVEventReview.h"
#import "Video.h"
#import "TVShowEpisode.h"
#import "SearchResultItem.h"
#import "PersonDetails.h"
#import "TVEventCredit.h"
#import "PostResponse.h"
#import "FavoritePostObject.h"
#import "WatchlistPostObject.h"
#import <KeychainItemWrapper.h>
#import "VirtualDataStorage.h"
#import "AccountDetails.h"
#import "DatabaseManager.h"

@interface DataProviderService(){
    RKObjectManager *objectManager;
    id<LoginManagerDelegate> _loginHandler;
}
@end

static const NSUInteger TVEventsPageSize=20;

@implementation DataProviderService
static DataProviderService *sharedService;

+(DataProviderService *)sharedDataProviderService{
    if(!sharedService){
        sharedService=[[DataProviderService alloc]init];
        [sharedService configure];
        
    }
    return sharedService;
}
-(void)configure{
    
    
    AFRKHTTPClient *httpClient = [[AFRKHTTPClient alloc] initWithBaseURL:[MovieAppConfiguration getApiBaseURL]];
    
    objectManager = [[RKObjectManager alloc] initWithHTTPClient:httpClient];
    
    NSString *subpathForMovies=[DataProviderService getSubpathForClass:[Movie class]];
    NSString *subpathForTvShows=[DataProviderService getSubpathForClass:[TVShow class]];
    
    NSString *pathPattern;
    
    RKObjectMapping *movieMapping = [RKObjectMapping mappingForClass:[Movie class]];
    RKObjectMapping *tvShowMapping = [RKObjectMapping mappingForClass:[TVShow class]];
    RKObjectMapping *genreMapping = [RKObjectMapping mappingForClass:[Genre class]];
    RKObjectMapping *crewMapping = [RKObjectMapping mappingForClass:[CrewMember class]];
    RKObjectMapping *castMapping = [RKObjectMapping mappingForClass:[CastMember class]];
    RKObjectMapping *movieDetailsMapping = [RKObjectMapping mappingForClass:[MovieDetails class]];
    RKObjectMapping *tvShowDetailsMapping = [RKObjectMapping mappingForClass:[TVShowDetails class]];
    RKObjectMapping *tvShowSeasonMapping = [RKObjectMapping mappingForClass:[TvShowSeason class]];
    RKObjectMapping *imageMapping = [RKObjectMapping mappingForClass:[Image class]];
    RKObjectMapping *reviewMapping = [RKObjectMapping mappingForClass:[TVEventReview class]];
    RKObjectMapping *videoMapping = [RKObjectMapping mappingForClass:[Video class]];
    RKObjectMapping *episodeMapping = [RKObjectMapping mappingForClass:[TVShowEpisode class]];
    RKObjectMapping *searchItemMapping = [RKObjectMapping mappingForClass:[SearchResultItem class]];
    RKObjectMapping *personDetailsMapping = [RKObjectMapping mappingForClass:[PersonDetails class]];
    RKObjectMapping *tvEventCreditMapping = [RKObjectMapping mappingForClass:[TVEventCredit class]];
    RKObjectMapping *postResponseMapping = [RKObjectMapping mappingForClass:[PostResponse class]];
    RKObjectMapping *accountDetailsMapping = [RKObjectMapping mappingForClass:[AccountDetails class]];

    
    [movieMapping addAttributeMappingsFromDictionary:[Movie propertiesMapping]];
    [tvShowMapping addAttributeMappingsFromDictionary:[TVShow propertiesMapping]];
    [genreMapping addAttributeMappingsFromDictionary:[Genre propertiesMapping]];
    [crewMapping addAttributeMappingsFromDictionary:[CrewMember propertiesMapping]];
    [castMapping addAttributeMappingsFromDictionary:[CastMember propertiesMapping]];
    [movieDetailsMapping addAttributeMappingsFromDictionary:[MovieDetails propertiesMapping]];
    [tvShowDetailsMapping addAttributeMappingsFromDictionary:[TVShowDetails propertiesMapping]];
    [tvShowSeasonMapping addAttributeMappingsFromDictionary:[TvShowSeason propertiesMapping]];
    [imageMapping addAttributeMappingsFromDictionary:[Image propertiesMapping]];
    [reviewMapping addAttributeMappingsFromArray:[TVEventReview propertiesNames]];
    [videoMapping addAttributeMappingsFromArray:[Video propertiesNames]];
    [episodeMapping addAttributeMappingsFromDictionary:[TVShowEpisode propertiesMapping]];
    [searchItemMapping addAttributeMappingsFromDictionary:[SearchResultItem propertiesMapping]];
    [personDetailsMapping addAttributeMappingsFromDictionary:[PersonDetails propertiesMapping]];
    [tvEventCreditMapping addAttributeMappingsFromDictionary:[TVEventCredit propertiesMapping]];
    [postResponseMapping addAttributeMappingsFromDictionary:[PostResponse propertiesMapping]];
    [accountDetailsMapping addAttributeMappingsFromDictionary:[AccountDetails propertiesMapping]];

    
    pathPattern=[subpathForMovies stringByAppendingString:VariableSubpath];
    [self addResponseDescriptorWithMapping:movieMapping pathPattern:pathPattern keyPath:ResultsPath forHttpMethod:GET];
    pathPattern=[subpathForTvShows stringByAppendingString:VariableSubpath];
    [self addResponseDescriptorWithMapping:tvShowMapping pathPattern:pathPattern keyPath:ResultsPath forHttpMethod:GET];
    
    
    [self addResponseDescriptorWithMapping:movieMapping pathPattern:MovieDiscoverSubpath keyPath:ResultsPath forHttpMethod:GET];
    [self addResponseDescriptorWithMapping:movieMapping pathPattern:FavoriteMovieFullSubpath keyPath:ResultsPath forHttpMethod:GET];
    [self addResponseDescriptorWithMapping:movieMapping pathPattern:WatchlistMovieFullSubpath keyPath:ResultsPath forHttpMethod:GET];
    [self addResponseDescriptorWithMapping:movieMapping pathPattern:RatedMoviesFullSubpath keyPath:ResultsPath forHttpMethod:GET];

    [self addResponseDescriptorWithMapping:tvShowMapping pathPattern:TVShowDiscoverSubpath keyPath:ResultsPath forHttpMethod:GET];
    [self addResponseDescriptorWithMapping:tvShowMapping pathPattern:FavoriteTVShowFullSubpath keyPath:ResultsPath forHttpMethod:GET];
    [self addResponseDescriptorWithMapping:tvShowMapping pathPattern:WatchlistTVShowFullSubpath keyPath:ResultsPath forHttpMethod:GET];
    [self addResponseDescriptorWithMapping:tvShowMapping pathPattern:RatedTVShowsFullSubpath keyPath:ResultsPath forHttpMethod:GET];

    [self addResponseDescriptorWithMapping:genreMapping pathPattern:nil keyPath:GenresKeypath forHttpMethod:GET];
    [self addResponseDescriptorWithMapping:movieDetailsMapping pathPattern:[MovieDetailsSubpath stringByAppendingString:VariableSubpath] keyPath:EmptyString forHttpMethod:GET];
    [self addResponseDescriptorWithMapping:tvShowDetailsMapping pathPattern:[TVShowDetailsSubpath stringByAppendingString:VariableSubpath] keyPath:EmptyString forHttpMethod:GET];
    [self addResponseDescriptorWithMapping:crewMapping pathPattern:nil keyPath:CrewKeypath forHttpMethod:GET];
    [self addResponseDescriptorWithMapping:castMapping pathPattern:nil keyPath:CastKeypath forHttpMethod:GET];
    [self addResponseDescriptorWithMapping:tvShowSeasonMapping pathPattern:[TVShowDetailsSubpath stringByAppendingString:VariableSubpath ] keyPath:SeasonsKeypath forHttpMethod:GET];
    [self addResponseDescriptorWithMapping:imageMapping pathPattern:AppendedImagesSubpath keyPath:ImageKeypath forHttpMethod:GET];
    [self addResponseDescriptorWithMapping:reviewMapping pathPattern:AppendedImagesSubpath keyPath:ReviewKeypath forHttpMethod:GET];
    [self addResponseDescriptorWithMapping:videoMapping pathPattern:[MovieDetailsSubpath stringByAppendingString: VideosForMovieSubpath] keyPath:ResultsPath forHttpMethod:GET];
    [self addResponseDescriptorWithMapping:episodeMapping pathPattern:[TVShowDetailsSubpath stringByAppendingString: EpisodeDetailsSubpath] keyPath:EpisodesKeypath forHttpMethod:GET];
    [self addResponseDescriptorWithMapping:videoMapping pathPattern:[TVShowDetailsSubpath stringByAppendingString:VideosForEpisodeSubpath] keyPath:ResultsPath forHttpMethod:GET];

    [self addResponseDescriptorWithMapping:searchItemMapping pathPattern:SearchMultiSubpath keyPath:ResultsPath forHttpMethod:GET];
    [self addResponseDescriptorWithMapping:personDetailsMapping pathPattern:[PersonDetailsSubpath stringByAppendingString:VariableSubpath]  keyPath:EmptyString forHttpMethod:GET];
 
    [self addResponseDescriptorWithMapping:tvEventCreditMapping pathPattern:[PersonDetailsSubpath stringByAppendingString:VariableSubpath] keyPath:CastCreditsKeypath forHttpMethod:GET];
    
    [self addResponseDescriptorWithMapping:postResponseMapping pathPattern:nil keyPath:EmptyString forHttpMethod:POST];
    [self addResponseDescriptorWithMapping:accountDetailsMapping pathPattern:AccountInfoSubpath  keyPath:EmptyString forHttpMethod:GET];

    
}

-(void)getTvEventsByCriterion:(Criterion)criterion page:(NSUInteger)page returnToHandler:(id<ItemsArrayReceiver>)delegate{

    //if no connection
    Class currentClass=((TVEventsViewController *)delegate).isMovieViewController ? [Movie class] : [TVShow class];
    if(![MovieAppConfiguration isConnectedToInternet]){
        CollectionType collection=[DataProviderService collectionTypeFromCriterion:criterion];
        NSArray *tvEvents;

        if(currentClass==[Movie class]){
            tvEvents=[[DatabaseManager sharedDatabaseManager] getMoviesOfCollection:collection];

        }
        else{
            tvEvents=[[DatabaseManager sharedDatabaseManager] getTVShowsOfCollection:collection];

        }
      
        [delegate updateReceiverWithNewData:tvEvents info:nil];
        return;
    }
    
    
    //section end
    NSString *criterionForSorting;
    if(criterion==LATEST){
        criterionForSorting=(currentClass == [Movie class]) ? MovieLatestSubpath : TVShowLatestSubpath;
    }
    else{
        criterionForSorting=[DataProviderService getCriteriaForSorting][criterion];
    }
    NSString *subpath=[[DataProviderService getSubpathForClass:currentClass] stringByAppendingString:criterionForSorting];
    NSNumber *pageNumber=[NSNumber numberWithUnsignedInteger:page];
    NSDictionary *queryParams = @{APIKeyParameterName: [MovieAppConfiguration getApiKey],
                                  PageQueryParameterName:pageNumber};
    
    [[RKObjectManager sharedManager] getObjectsAtPath:subpath
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  NSArray *tvEvents = [NSMutableArray arrayWithArray: mappingResult.array];
                                                  if(criterion==LATEST){
                                                      NSMutableArray *latestMovies=[[NSMutableArray alloc] initWithCapacity:7];
                                                      for(int i=0;i<7 && i<tvEvents.count;i++){
                                                          TVEvent *currentTVEvent=tvEvents[i];
                                                          TVEvent *tvEvent=[[TVEvent alloc] init];
                                                          tvEvent.id=currentTVEvent.id;
                                                          tvEvent.title=currentTVEvent.title;
                                                          tvEvent.voteAverage=currentTVEvent.voteAverage;
                                                          tvEvent.posterPath=currentTVEvent.posterPath;
                                                          NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:tvEvent];

                                                          [latestMovies addObject:encodedObject];
                                                      }
                                                      NSUserDefaults *std=[[NSUserDefaults standardUserDefaults] initWithSuiteName:AppGroupSuiteName];
                                                      [std setObject:latestMovies forKey:LatestMoviesUserDefaultsKey];
                                                      NSArray *tmp=[std objectForKey:LatestMoviesUserDefaultsKey];

                                                  }
                                                  [[DatabaseManager sharedDatabaseManager] addTVEventsFromArray:tvEvents toCollection:[DataProviderService collectionTypeFromCriterion:criterion]];
                                                  [delegate updateReceiverWithNewData:tvEvents info:@{CriterionDictionaryKey:[DataProviderService getCriteriaForSorting][criterion]}];
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  [delegate updateReceiverWithNewData:nil info:@{ErrorDictionaryKey:error}];
                                              }];
    
    
}

-(void)getGenresForTvEvent:(Class)class ReturnTo:(id<ItemsArrayReceiver>)delegate{
    
    NSDictionary *queryParams = @{APIKeyParameterName: [MovieAppConfiguration getApiKey]};
    
    [[RKObjectManager sharedManager] getObjectsAtPath:(class == [Movie class]) ? MovieGenresSubpath : TVShowGenresSubpath
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  [delegate updateReceiverWithNewData:mappingResult.array info:@{TypeDictionaryKey: [class getClassName]}];
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  //MISSING ERROR HANDLING
                                                  NSLog(@"Error: %@", error);
                                              }];
    
}
//in this method we get in response objects: tv event details, images, reviews and seasons
-(void)getDetailsForTvEvent:(TVEvent *)tvEvent returnTo:(id)dataHandler{
    MediaType mediaType= [tvEvent isKindOfClass:[Movie class]] ? MovieType : TVShowType;
    if(![MovieAppConfiguration isConnectedToInternet]){
        NSMutableArray *results=[[NSMutableArray alloc] init];
        if(mediaType==TVShowType){
            [results addObject:[[DatabaseManager sharedDatabaseManager] getTVShowWithID:tvEvent.id]];
            [results addObjectsFromArray:[[DatabaseManager sharedDatabaseManager] getSeasonsForTVShow:(TVShow *)tvEvent]];
        }
        else{
            [results addObject:[[DatabaseManager sharedDatabaseManager] getMovieWithID:tvEvent.id]];
            [results addObjectsFromArray:[[DatabaseManager sharedDatabaseManager] getReviewsForTVEvent:tvEvent]];
        }
        [results addObjectsFromArray:[[DatabaseManager sharedDatabaseManager] getImagesForTVEvent:tvEvent]];
        [dataHandler updateReceiverWithNewData:results info:@{TypeDictionaryKey:DetailsDictionaryValue}];
        return;
        
    }
    NSDictionary *queryParams = @{APIKeyParameterName : [MovieAppConfiguration getApiKey],
                                  AppendToResponseParameterName : AppendImagesParameterValue};
    NSString *subpath;
    if([tvEvent isKindOfClass:[Movie class]]){
        subpath=MovieDetailsSubpath;
    }
    else{
        subpath=TVShowDetailsSubpath;
    }
    
    subpath=[subpath stringByAppendingString:[NSString stringWithFormat:@"/%lu",tvEvent.id]];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:subpath
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  NSArray *results=mappingResult.array;
                                                  [[DatabaseManager sharedDatabaseManager] updateTVEvent:tvEvent.id withTVEventDetails:mappingResult.array[0]];
                                                  NSMutableArray *seasons=[[NSMutableArray alloc] init];
                                                  NSMutableArray *images=[[NSMutableArray alloc] init];
                                                  NSMutableArray *reviews=[[NSMutableArray alloc] init];
                                                  for(int i=0;i<results.count;i++){
                                                      if([results[i] isKindOfClass:[TvShowSeason class]]){
                                                          [seasons addObject:results[i]];
                                                      }
                                                      else if([results[i] isKindOfClass:[Image class]]){
                                                          [images addObject:results[i]];
                                                      }
                                                      else if([results[i] isKindOfClass:[TVEventReview class]]){
                                                          [reviews addObject:results[i]];
                                                      }
                                                      
                                                      
                                                  }
                                                  if([tvEvent isKindOfClass:[TVShow class]]){
                                                      
                                                      [[DatabaseManager sharedDatabaseManager] addTVShowSeasonsFromArray:seasons toTVShowWithID:tvEvent.id];
                                                  }
                                                  else{
                                                      [[DatabaseManager sharedDatabaseManager] addReviewsFromArray:reviews toMovie:tvEvent];
                                                  }
                                                  [[DatabaseManager sharedDatabaseManager] addImagesFromArray:images toTVEvent:tvEvent];
                                                  
                                                  
                                                  [dataHandler updateReceiverWithNewData:mappingResult.array info:@{TypeDictionaryKey:DetailsDictionaryValue}];
                                                  
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  //MISSING ERROR HANDLING
                                                  NSLog(@"Error: %@", error);
                                              }];
    
    
}
//not in use - but maybe will be needed
-(void)getDetailsForTvEventWithID:(NSUInteger)tvEventID mediaType:(MediaType)mediaType returnTo:(id<ItemsArrayReceiver>)dataHandler{
    NSDictionary *queryParams = @{APIKeyParameterName : [MovieAppConfiguration getApiKey],
                                  AppendToResponseParameterName : AppendImagesParameterValue};
    NSString *subpath;
    if(mediaType==MovieType){
        subpath=MovieDetailsSubpath;
    }
    else{
        subpath=TVShowDetailsSubpath;
    }
    
    subpath=[subpath stringByAppendingString:[NSString stringWithFormat:@"/%lu",tvEventID]];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:subpath
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  [dataHandler updateReceiverWithNewData:mappingResult.array info:@{TypeDictionaryKey:DetailsDictionaryValue}];
                                                  
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  //MISSING ERROR HANDLING
                                                  NSLog(@"Error: %@", error);
                                              }];
    
    
}

-(void)getCreditsForTvEvent:(TVEvent *)tvEvent returnTo:(id)dataHandler{
    if(![MovieAppConfiguration isConnectedToInternet]){
        NSMutableArray *results=[[NSMutableArray alloc] init];
        [results addObjectsFromArray:[[DatabaseManager sharedDatabaseManager] getCastMembersForTVEvent:tvEvent]];
        [results addObjectsFromArray:[[DatabaseManager sharedDatabaseManager] getCrewMembersForTVEvent:tvEvent]];
        [dataHandler updateReceiverWithNewData:results info:nil];
        return;
        
    }
    NSDictionary *queryParams = @{APIKeyParameterName: [MovieAppConfiguration getApiKey]};
    NSString *subpath;
    if([tvEvent isKindOfClass:[Movie class]]){
        subpath=MovieDetailsSubpath;
    }
    else{
        subpath=TVShowDetailsSubpath;
    }
    
    subpath=[[subpath stringByAppendingString:[NSString stringWithFormat:@"/%lu",tvEvent.id]] stringByAppendingString:CreditsKeypath];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:subpath
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  NSArray *results=mappingResult.array;
                                                  NSMutableArray *crewMembers=[[NSMutableArray alloc] init];
                                                  NSMutableArray *castMembers=[[NSMutableArray alloc] init];
                                                  
                                                  for(int i=0;i<results.count;i++){
                                                      if([results[i] isKindOfClass:[CastMember class]]){
                                                          [castMembers addObject:results[i]];
                                                      }
                                                      else if([results[i] isKindOfClass:[CrewMember class]]){
                                                          [crewMembers addObject:results[i]];
                                                      }
                                                  }
                                                  
                                                  [[DatabaseManager sharedDatabaseManager] addCastMembersFromArray:castMembers toTVEvent:tvEvent];
                                                  [[DatabaseManager sharedDatabaseManager] addCrewMembers:crewMembers toTVEvent:tvEvent];

                                                  [dataHandler updateReceiverWithNewData:mappingResult.array info:@{TypeDictionaryKey:CreditsDictionaryValue}];
                                                  
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  //MISSING ERROR HANDLING
                                                  NSLog(@"Error: %@", error);
                                              }];
    
    
}

-(void)getVideosForTvEventID:(NSUInteger)tvEventID returnTo:(id<ItemsArrayReceiver>)dataHandler{
    NSDictionary *queryParams = @{APIKeyParameterName: [MovieAppConfiguration getApiKey]};
    NSString *subpath;
    if(![MovieAppConfiguration isConnectedToInternet]){
        return;
    }
    subpath=[[MovieDetailsSubpath stringByAppendingString:[NSString stringWithFormat:@"/%lu",tvEventID]] stringByAppendingString:VideosSubpath];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:subpath
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  [dataHandler updateReceiverWithNewData:mappingResult.array info:nil];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  //MISSING ERROR HANDLING
                                                  NSLog(@"Error: %@", error);
                                              }];
    
}

//this method also fetches episodes for season
-(void)getSeasonDetailsForTvShow:(NSUInteger)tvShowID seasonNumber:(NSUInteger)number returnTo:(id<ItemsArrayReceiver>)dataHandler{
    
    if(![MovieAppConfiguration isConnectedToInternet]){
        NSArray *episodes=[[DatabaseManager sharedDatabaseManager] getEpisodesForTVShowWithID:tvShowID seasonNumber:number];
        [dataHandler updateReceiverWithNewData:episodes info:nil];
        return;
    }
    
    NSDictionary *queryParams = @{APIKeyParameterName: [MovieAppConfiguration getApiKey]};
    NSString *subpath;
   
    subpath=[[TVShowDetailsSubpath stringByAppendingString:[NSString stringWithFormat:@"/%lu",tvShowID]] stringByAppendingString:[NSString stringWithFormat:@"/season/%lu",number]];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:subpath
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  NSMutableArray *episodes=[[NSMutableArray alloc] init];
                                                  for(int i=0;i<mappingResult.array.count;i++){
                                                      if([mappingResult.array[i] isKindOfClass:[TVShowEpisode class]]){
                                                          [episodes addObject:mappingResult.array[i]];
                                                      }
                                                  }
                                                  [[DatabaseManager sharedDatabaseManager] addTVShowEpisodesFromArray:episodes toTVShowWithID:tvShowID seasoNumber:number];
                                                  [dataHandler updateReceiverWithNewData:mappingResult.array info:@{TypeDictionaryKey:EpisodesDictionaryValue, TVEventIDDictionaryKey:[NSNumber numberWithUnsignedInteger:tvShowID]}];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  //MISSING ERROR HANDLING
                                                  NSLog(@"Error: %@", error);
                                              }];
    
}

-(void)getVideosForTvShowID:(NSUInteger)tvShowID seasonNumber:(NSUInteger)seasonNumber episodeNumber:(NSUInteger)episodeNumber returnTo:(id<ItemsArrayReceiver>)dataHandler{
    if(![MovieAppConfiguration isConnectedToInternet]){
        return;
    }
    NSDictionary *queryParams = @{APIKeyParameterName: [MovieAppConfiguration getApiKey]};
    NSString *subpath;
    
    subpath=[TVShowDetailsSubpath stringByAppendingString:[NSString stringWithFormat:@"/%lu/season/%lu/episode/%lu/videos",tvShowID, seasonNumber, episodeNumber]];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:subpath
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  [dataHandler updateReceiverWithNewData:mappingResult.array info:nil];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  //MISSING ERROR HANDLING
                                                  NSLog(@"Error: %@", error);
                                              }];
    
}

-(void)getCastForTvShowID:(NSUInteger)tvShowID seasonNumber:(NSUInteger)seasonNumber episodeNumber:(NSUInteger)episodeNumber returnTo:(id<ItemsArrayReceiver>)dataHandler{
    if(![MovieAppConfiguration isConnectedToInternet]){
        NSArray *results=[[DatabaseManager sharedDatabaseManager] getCastMembersForTVShowWithID:tvShowID easonNumber:seasonNumber episodeNumber:episodeNumber];
        [dataHandler updateReceiverWithNewData:results info:nil];
        return;
    }
    NSDictionary *queryParams = @{APIKeyParameterName: [MovieAppConfiguration getApiKey]};
    NSString *subpath;
    
    subpath=[TVShowDetailsSubpath stringByAppendingString:[NSString stringWithFormat:@"/%lu/season/%lu/episode/%lu/credits",tvShowID, seasonNumber, episodeNumber]];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:subpath
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  NSMutableArray *cast=[[NSMutableArray alloc] init];
                                                  for(int i=0;i<mappingResult.array.count;i++){
                                                      if([mappingResult.array[i] isKindOfClass:[CastMember class]]){
                                                          [cast addObject:mappingResult.array[i]];
                                                      }
                                                  }
                                                  [[DatabaseManager sharedDatabaseManager] addCastMembersFromArray:cast toTVShowWithID:tvShowID seasonNumber:seasonNumber episodeNumber:episodeNumber];
                                                  [dataHandler updateReceiverWithNewData:mappingResult.array info:nil];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  //MISSING ERROR HANDLING
                                                  NSLog(@"Error: %@", error);
                                              }];
    
}

-(void)performMultiSearchWithQuery:(NSString *)query page:(NSUInteger)page returnTo:(id<ItemsArrayReceiver>)dataHandler{
    
    if(![MovieAppConfiguration isConnectedToInternet]){
        NSArray *results=[[DatabaseManager sharedDatabaseManager] getTVEventsForSearchQuery:query];
        [dataHandler updateReceiverWithNewData:results info:nil];
        return;
    }
    
    NSDictionary *queryParams = @{QueryParameterName : query,
                                  PageQueryParameterName:[NSNumber numberWithUnsignedInteger:page],
                                  APIKeyParameterName: [MovieAppConfiguration getApiKey]
                                  };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:SearchMultiSubpath
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  [dataHandler updateReceiverWithNewData:mappingResult.array info:nil];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  //MISSING ERROR HANDLING
                                                  NSLog(@"Error: %@", error);
                                              }];
}

-(void)getPersonDetailsForID:(NSUInteger)personID returnTo:(id<ItemsArrayReceiver>)dataHandler{
    if(![MovieAppConfiguration isConnectedToInternet]){
        NSMutableArray *personDetails=[[NSMutableArray alloc] init];
        [personDetails addObject:[[DatabaseManager sharedDatabaseManager] getPersonDetailsForID:personID]];
        [dataHandler updateReceiverWithNewData:personDetails info:nil];
        return;
    }
    NSDictionary *queryParams = @{APIKeyParameterName : [MovieAppConfiguration getApiKey],
                                  AppendToResponseParameterName : AppendCombinedCreditsParameterValue};
    NSString *subpath;
    
    subpath=[PersonDetailsSubpath stringByAppendingString:[NSString stringWithFormat:@"/%d",(int)personID]];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:subpath
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  [[DatabaseManager sharedDatabaseManager] addPerson:mappingResult.array[0]];
                                                  [dataHandler updateReceiverWithNewData:mappingResult.array info:nil];
                                                  
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  //MISSING ERROR HANDLING
                                                  NSLog(@"Error: %@", error);
                                              }];
    
}

-(void)getFavoriteTVEventsOfType:(MediaType)mediaType pageNumber:(NSUInteger)pageNumber returnTo:(id<ItemsArrayReceiver>)dataHandler{
    NSString *sessionID;
    if(![self isUserLoggedIn]){
        return;
    }
    else{
        sessionID=[self getSessionID];
    }
    if(![MovieAppConfiguration isConnectedToInternet]){
        NSArray *favorites;
        if(mediaType==MovieType){
            favorites=[[DatabaseManager sharedDatabaseManager] getMoviesOfCollection:CollectionTypeFavorites];

        }
        else{
            favorites=[[DatabaseManager sharedDatabaseManager] getTVShowsOfCollection:CollectionTypeFavorites];
        }
        [dataHandler updateReceiverWithNewData:favorites info:@{SideMenuOptionDictionaryKey:[NSNumber numberWithInt:SideMenuOptionFavorites]}];
        return;
        
    }
    NSDictionary *queryParams = @{APIKeyParameterName : [MovieAppConfiguration getApiKey],
                                  SessionIDParameterName: sessionID,
                                  PageQueryParameterName: [NSNumber numberWithUnsignedInteger:pageNumber],
                                  SortByParameterName: @"created_at.desc"};
    NSString *subpath=[[AccountDetailsSubpath stringByAppendingString:FavoriteSubpath] stringByAppendingString:mediaType==MovieType ? @"/movies" : @"/tv" ];
    [[RKObjectManager sharedManager] getObjectsAtPath:subpath
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  [dataHandler updateReceiverWithNewData:mappingResult.array info:@{SideMenuOptionDictionaryKey:[NSNumber numberWithInt:SideMenuOptionFavorites]}];
                                                  
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  [dataHandler updateReceiverWithNewData:nil info:@{SideMenuOptionDictionaryKey:[NSNumber numberWithInt:SideMenuOptionFavorites]}];  
                                              }];

    
}
-(void)getWatchlistOfType:(MediaType)mediaType pageNumber:(NSUInteger)pageNumber returnTo:(id<ItemsArrayReceiver>)dataHandler{
    NSString *sessionID;
    if(![self isUserLoggedIn]){
        return;
    }
    else{
        sessionID=[self getSessionID];
    }
    if(![MovieAppConfiguration isConnectedToInternet]){
        NSArray *watchlist;
        if(mediaType==MovieType){
            watchlist=[[DatabaseManager sharedDatabaseManager] getMoviesOfCollection:CollectionTypeWatchlist];
            
        }
        else{
            watchlist=[[DatabaseManager sharedDatabaseManager] getTVShowsOfCollection:CollectionTypeWatchlist];
        }
        [dataHandler updateReceiverWithNewData:watchlist info:@{SideMenuOptionDictionaryKey:[NSNumber numberWithInt:SideMenuOptionWatchlist]}];
        return;
        
    }
    
    NSDictionary *queryParams = @{APIKeyParameterName : [MovieAppConfiguration getApiKey],
                                  SessionIDParameterName: sessionID,
                                  PageQueryParameterName: [NSNumber numberWithUnsignedInteger:pageNumber],
                                  SortByParameterName: @"created_at.desc"};
    NSString *subpath=[[AccountDetailsSubpath stringByAppendingString:WatchlistSubpath] stringByAppendingString:mediaType==MovieType ? @"/movies" : @"/tv" ];
    [[RKObjectManager sharedManager] getObjectsAtPath:subpath
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  [dataHandler updateReceiverWithNewData:mappingResult.array info:@{SideMenuOptionDictionaryKey:[NSNumber numberWithInt:SideMenuOptionWatchlist]}];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  [dataHandler updateReceiverWithNewData:nil info:@{SideMenuOptionDictionaryKey:[NSNumber numberWithInt:SideMenuOptionWatchlist]}];
                                              }];
}

-(void)getRatedTVEventsOfType:(MediaType)mediaType pageNumber:(NSUInteger)pageNumber returnTo:(id<ItemsArrayReceiver>)dataHandler{
    NSString *sessionID;
    if(![self isUserLoggedIn]){
        return;
    }
    else{
        sessionID=[self getSessionID];
    }
    
    NSDictionary *queryParams = @{APIKeyParameterName : [MovieAppConfiguration getApiKey],
                                  SessionIDParameterName: sessionID,
                                  PageQueryParameterName: [NSNumber numberWithUnsignedInteger:pageNumber],
                                  SortByParameterName: @"created_at.desc"};
    NSString *subpath=[[AccountDetailsSubpath stringByAppendingString:RatedSubpath] stringByAppendingString:mediaType==MovieType ? @"/movies" : @"/tv" ];
    [[RKObjectManager sharedManager] getObjectsAtPath:subpath
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  [dataHandler updateReceiverWithNewData:mappingResult.array info:@{SideMenuOptionDictionaryKey:[NSNumber numberWithInt:SideMenuOptionRatings]}];
                                                  
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
[dataHandler updateReceiverWithNewData:nil info:@{SideMenuOptionDictionaryKey:[NSNumber numberWithInt:SideMenuOptionRatings]}];
                                              }];
}

+(NSArray *)getCriteriaForSorting{
    return @[@"/popular",@"/latest",@"/top_rated",@"/airing_today",@"/on_the_air"];
}

+(NSString *)getSubpathForClass:(Class)class{
    return (class == [Movie class]) ? MovieDetailsSubpath : TVShowDetailsSubpath;
}

-(void)addResponseDescriptorWithMapping:(RKObjectMapping *)mapping pathPattern:(NSString *)pathPattern keyPath:(NSString *)keyPath forHttpMethod:(HTTPMethod)method{
    NSIndexSet *postIndexSet=[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 2)];
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:mapping
                                                 method:method==GET ? RKRequestMethodGET : RKRequestMethodPOST
                                            pathPattern:pathPattern
                                                keyPath:keyPath
                                            statusCodes:method==GET ? [NSIndexSet indexSetWithIndex:200] : postIndexSet];
    
    [objectManager addResponseDescriptor:responseDescriptor];
}

-(void)cancelAllRequests{
    [[objectManager operationQueue] cancelAllOperations];
}


//POST methods

-(void)rateTVEventWithID:(NSUInteger)tvEventID rating:(CGFloat)rating mediaType:(MediaType)mediaType responseHandler:(id<TVEventsCollectionsStateChangeHandler>)responseHandler{
    NSString *sessionID;
    if(![self isUserLoggedIn]){
        return;
    }
    else{
        sessionID=[self getSessionID];
    }
    if(![MovieAppConfiguration isConnectedToInternet]){
        [[DatabaseManager sharedDatabaseManager] offlineModeRateTVEventWithID:tvEventID meidaType:mediaType rating:rating];
        [responseHandler addedTVEventWithID:tvEventID toCollectionOfType:SideMenuOptionRatings];
        return;
    }
    NSMutableDictionary *postObject=[NSMutableDictionary dictionaryWithDictionary:@{ValueParameterName : [NSNumber numberWithFloat:rating]}];
    
    RKObjectMapping *postObjectMapping=[RKObjectMapping requestMapping];
    [postObjectMapping addAttributeMappingsFromDictionary:@{@"value":@"value"}];
    
    RKRequestDescriptor *postRequestDescriptor=[RKRequestDescriptor requestDescriptorWithMapping:postObjectMapping objectClass:[NSMutableDictionary class] rootKeyPath:nil method:RKRequestMethodAny];
    [[RKObjectManager sharedManager] addRequestDescriptor:postRequestDescriptor];
    NSString *subpath=mediaType==MovieType ? MovieDetailsSubpath : TVShowDetailsSubpath;
    subpath=[subpath stringByAppendingString:[NSString stringWithFormat:@"/%d/rating", (int)tvEventID]];
    subpath=[[subpath stringByAppendingString:@"?api_key="] stringByAppendingString:[MovieAppConfiguration getApiKey]];
    subpath=[[subpath stringByAppendingString:@"&session_id="] stringByAppendingString:sessionID];
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    
    [[RKObjectManager sharedManager] postObject:postObject path:subpath parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        PostResponse *response=mappingResult.array[0];
        if(response.statusCode==AddedSucessfullyPostResponseStatusCode || response.statusCode==UpdatedSucessfullyPostResponseStatusCode){
            [[DatabaseManager sharedDatabaseManager] addToRatingsTVEventWithID:tvEventID mediaType:mediaType rating:rating];
            [responseHandler addedTVEventWithID:tvEventID toCollectionOfType:SideMenuOptionRatings];
        }
        else if(response.statusCode==RemovedSucessfullyPostResponseStatusCode){
            [responseHandler removedTVEventWithID:tvEventID fromCollectionOfType:SideMenuOptionRatings];
        }
    }
                                        failure:^(RKObjectRequestOperation *operation, NSError *error) {
    }];
}

-(void)favoriteTVEventWithID:(NSUInteger)tvEventID mediaType:(MediaType)mediaType remove:(BOOL)shouldRemove responseHandler:(id<TVEventsCollectionsStateChangeHandler>)responseHandler{
    NSString *sessionID;
    if(![self isUserLoggedIn]){
        return;
    }
    else{
        sessionID=[self getSessionID];
    }
    if(![MovieAppConfiguration isConnectedToInternet]){
        [[DatabaseManager sharedDatabaseManager] offlineModeAddTVEventWithID:tvEventID mediaType:mediaType toCollectionIn:CollectionTypeFavorites shouldRemove:shouldRemove];
        if(shouldRemove){
            [responseHandler removedTVEventWithID:tvEventID fromCollectionOfType:SideMenuOptionFavorites];
        }
        else{
            [responseHandler addedTVEventWithID:tvEventID toCollectionOfType:SideMenuOptionFavorites];
        }

        return;
    }
    FavoritePostObject *postObject=[[FavoritePostObject alloc] initWithMediaID:tvEventID mediaType:mediaType status:!shouldRemove];
    
    RKObjectMapping *postObjectMapping=[RKObjectMapping requestMapping];
    [postObjectMapping addAttributeMappingsFromDictionary:[FavoritePostObject propertiesMapping]];
    
    RKRequestDescriptor *postRequestDescriptor=[RKRequestDescriptor requestDescriptorWithMapping:[postObjectMapping inverseMapping] objectClass:[FavoritePostObject class] rootKeyPath:nil method:RKRequestMethodAny];
    [[RKObjectManager sharedManager] addRequestDescriptor:postRequestDescriptor];
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];

    NSString *subpath=[AccountDetailsSubpath stringByAppendingString:FavoriteSubpath];
    subpath=[[subpath stringByAppendingString:@"?api_key="] stringByAppendingString:[MovieAppConfiguration getApiKey]];
    subpath=[[subpath stringByAppendingString:@"&session_id="] stringByAppendingString:sessionID];
    
    [[RKObjectManager sharedManager] postObject:postObject path:subpath parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        PostResponse *response=mappingResult.array[0];
        if(response.statusCode==AddedSucessfullyPostResponseStatusCode){
            [[DatabaseManager sharedDatabaseManager] addTVEventWithID:tvEventID mediaType:mediaType toCollection:CollectionTypeFavorites];
            [responseHandler addedTVEventWithID:tvEventID toCollectionOfType:SideMenuOptionFavorites];
        }
        else if(response.statusCode==RemovedSucessfullyPostResponseStatusCode){
            [[DatabaseManager sharedDatabaseManager] removeTVEventWithID:tvEventID mediaType:mediaType fromCollection:CollectionTypeFavorites];
            [responseHandler removedTVEventWithID:tvEventID fromCollectionOfType:SideMenuOptionFavorites];
        }

    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        //missing handling
    }];
}

-(void)addToWatchlistTVEventWithID:(NSUInteger)tvEventID mediaType:(MediaType)mediaType remove:(BOOL)shouldRemove responseHandler:(id<TVEventsCollectionsStateChangeHandler>)responseHandler{
    NSString *sessionID;
    if(![self isUserLoggedIn]){
        return;
    }
    else{
        sessionID=[self getSessionID];
    }
    if(![MovieAppConfiguration isConnectedToInternet]){
        [[DatabaseManager sharedDatabaseManager] offlineModeAddTVEventWithID:tvEventID mediaType:mediaType toCollectionIn:CollectionTypeWatchlist shouldRemove:shouldRemove];
        
        if(shouldRemove){
            [responseHandler removedTVEventWithID:tvEventID fromCollectionOfType:SideMenuOptionWatchlist];
        }
        else{
            [responseHandler addedTVEventWithID:tvEventID toCollectionOfType:SideMenuOptionWatchlist];
        }
        
        return;
    }
    WatchlistPostObject *postObject=[[WatchlistPostObject alloc] initWithMediaID:tvEventID mediaType:mediaType status:!shouldRemove];
    
    RKObjectMapping *postObjectMapping=[RKObjectMapping requestMapping];
    [postObjectMapping addAttributeMappingsFromDictionary:[WatchlistPostObject propertiesMapping]];
    
    RKRequestDescriptor *postRequestDescriptor=[RKRequestDescriptor requestDescriptorWithMapping:[postObjectMapping inverseMapping] objectClass:[WatchlistPostObject class] rootKeyPath:nil method:RKRequestMethodAny];
    [[RKObjectManager sharedManager] addRequestDescriptor:postRequestDescriptor];
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    
    NSString *subpath=[AccountDetailsSubpath stringByAppendingString:WatchlistSubpath];
    subpath=[[subpath stringByAppendingString:@"?api_key="] stringByAppendingString:[MovieAppConfiguration getApiKey]];
    subpath=[[subpath stringByAppendingString:@"&session_id="] stringByAppendingString:sessionID];
    
    [[RKObjectManager sharedManager] postObject:postObject path:subpath parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        PostResponse *response=mappingResult.array[0];
        if(response.statusCode==AddedSucessfullyPostResponseStatusCode){
            [[DatabaseManager sharedDatabaseManager] addTVEventWithID:tvEventID mediaType:mediaType toCollection:CollectionTypeWatchlist];
            [responseHandler addedTVEventWithID:tvEventID toCollectionOfType:SideMenuOptionWatchlist];
        }
        else if(response.statusCode==RemovedSucessfullyPostResponseStatusCode){
            [[DatabaseManager sharedDatabaseManager] removeTVEventWithID:tvEventID mediaType:mediaType fromCollection:CollectionTypeWatchlist];
            [responseHandler removedTVEventWithID:tvEventID fromCollectionOfType:SideMenuOptionWatchlist];
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        //missing handling
    }];
}

-(BOOL)isUserLoggedIn{
    KeychainItemWrapper *myKeyChain=[[KeychainItemWrapper alloc] initWithIdentifier:KeyChainItemWrapperIdentifier accessGroup:nil];
    NSString *username=[myKeyChain objectForKey:(id)kSecAttrAccount];
    if(!username  || [username length]==0){
        return NO;
    }
    else{
        return YES;
    }
}

-(NSString *)getSessionID{
    KeychainItemWrapper *myKeyChain=[[KeychainItemWrapper alloc] initWithIdentifier:KeyChainItemWrapperIdentifier accessGroup:nil];
    NSString *sessionID=[myKeyChain objectForKey:(id)kSecValueData];
    return sessionID;
}

//helper methods for notification purposes
-(void)getAllEpisodesForTVShowWithID:(NSUInteger)tvShowID numberOfSeasons:(NSUInteger)numberOfSeasons  returnTo:(id<ItemsArrayReceiver>)dataHandler{
    if(numberOfSeasons>0){
            [self getSeasonDetailsForTvShow:tvShowID seasonNumber:numberOfSeasons returnTo:self];
    }
    else{
        [self getDetailsForTvEventWithID:tvShowID mediaType:TVShowType returnTo:self];
    }
}

-(void)updateReceiverWithNewData:(NSArray *)customItemsArray info:(NSDictionary *)info{
    if([[info objectForKey:TypeDictionaryKey] isEqualToString:DetailsDictionaryValue]){
        TVShowDetails *tvShow=customItemsArray[0];
        [self getAllEpisodesForTVShowWithID:tvShow.id numberOfSeasons:tvShow.numberOfSeasons returnTo:self];
        
    }
    else if([[info objectForKey:TypeDictionaryKey ] isEqualToString:EpisodesDictionaryValue]){
        [[VirtualDataStorage sharedVirtualDataStorage] updateReceiverWithNewData:customItemsArray info:@{TypeDictionaryKey:EpisodesDictionaryValue, TVEventIDDictionaryKey:[info objectForKey:TVEventIDDictionaryKey]}];
    }
}


-(void)getAccountDetailsReturnTo:(id<ItemsArrayReceiver>)dataHandler{
    NSString *sessionID;
    if(![self isUserLoggedIn]){
        return;
    }
    else{
        sessionID=[self getSessionID];
    }
    if(![MovieAppConfiguration isConnectedToInternet]){
        AccountDetails *accountDetails=[[DatabaseManager sharedDatabaseManager] getAccountDetailsForID:0];
        NSArray *results=[[NSArray alloc] initWithObjects:accountDetails, nil];
        [dataHandler updateReceiverWithNewData:results info:nil];
        return;
    }
    NSDictionary *queryParams = @{APIKeyParameterName : [MovieAppConfiguration getApiKey],
                                  SessionIDParameterName: sessionID};

    [[RKObjectManager sharedManager] getObjectsAtPath:AccountInfoSubpath
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  [dataHandler updateReceiverWithNewData:mappingResult.array info:nil];
                                                  [[DatabaseManager sharedDatabaseManager] addAccountDetails:mappingResult.array[0]];
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  
                                              }];
     
}

+(CollectionType)collectionTypeFromCriterion:(Criterion)criterion{
    switch (criterion) {
        case LATEST:
            return CollectionTypeLatest;
            break;
        case MOST_POPULAR:
            return CollectionTypePopular;
            break;
        case TOP_RATED:
            return CollectionTypeHighestRated;
            break;
        case ON_THE_AIR:
            return CollectionTypeOnTheAir;
            break;
        case AIRING_TODAY:
            return CollectionTypeAiringToday;
            break;
        default:
            break;
    }
}


+(CollectionType)collectionTypeFromSideMenuOption:(SideMenuOption)sideMenuOption{
    switch (sideMenuOption) {
        case SideMenuOptionFavorites:
            return CollectionTypeFavorites;
            break;
        case SideMenuOptionWatchlist:
            return CollectionTypeWatchlist;
            break;
        case SideMenuOptionRatings:
            return CollectionTypeRatings;
            break;
        default:
            @throw NSInternalInconsistencyException;
    }
}
@end
