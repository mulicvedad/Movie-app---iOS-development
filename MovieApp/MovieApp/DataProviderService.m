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

@interface DataProviderService(){
    RKObjectManager *objectManager;
    id<LoginManagerDelegate> _loginHandler;
    NSString *_sessionID;
}
@end

@implementation DataProviderService
static DataProviderService *sharedService;

+(id)init{
    if(!sharedService){
        sharedService=[super init];
    }
    return sharedService;
}
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

    
}

-(void)getTvEventsByCriterion:(Criterion)criterion page:(NSUInteger)page returnToHandler:(id<ItemsArrayReceiver>)delegate{

    Class currentClass=((TVEventsViewController *)delegate).isMovieViewController ? [Movie class] : [TVShow class];
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

-(void)getDetailsForTvEvent:(TVEvent *)tvEvent returnTo:(id)dataHandler{
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
                                                  [dataHandler updateReceiverWithNewData:mappingResult.array info:@{TypeDictionaryKey:DetailsDictionaryValue}];
                                                  
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  //MISSING ERROR HANDLING
                                                  NSLog(@"Error: %@", error);
                                              }];
    
    
}

-(void)getCreditsForTvEvent:(TVEvent *)tvEvent returnTo:(id)dataHandler{
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

-(void)getSeasonDetailsForTvShow:(NSUInteger)tvShowID seasonNumber:(NSUInteger)number returnTo:(id<ItemsArrayReceiver>)dataHandler{
    NSDictionary *queryParams = @{APIKeyParameterName: [MovieAppConfiguration getApiKey]};
    NSString *subpath;
    
    subpath=[[TVShowDetailsSubpath stringByAppendingString:[NSString stringWithFormat:@"/%lu",tvShowID]] stringByAppendingString:[NSString stringWithFormat:@"/season/%lu",number]];
    
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

-(void)getVideosForTvShowID:(NSUInteger)tvShowID seasonNumber:(NSUInteger)seasonNumber episodeNumber:(NSUInteger)episodeNumber returnTo:(id<ItemsArrayReceiver>)dataHandler{
    
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
    
    NSDictionary *queryParams = @{APIKeyParameterName: [MovieAppConfiguration getApiKey]};
    NSString *subpath;
    
    subpath=[TVShowDetailsSubpath stringByAppendingString:[NSString stringWithFormat:@"/%lu/season/%lu/episode/%lu/credits",tvShowID, seasonNumber, episodeNumber]];
    
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

-(void)performMultiSearchWithQuery:(NSString *)query page:(NSUInteger)page returnTo:(id<ItemsArrayReceiver>)dataHandler{
    
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
    NSDictionary *queryParams = @{APIKeyParameterName : [MovieAppConfiguration getApiKey],
                                  AppendToResponseParameterName : AppendCombinedCreditsParameterValue};
    NSString *subpath;
    
    subpath=[PersonDetailsSubpath stringByAppendingString:[NSString stringWithFormat:@"/%d",(int)personID]];
    
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

-(void)getFavoriteTVEventsOfType:(MediaType)mediaType pageNumber:(NSUInteger)pageNumber returnTo:(id<ItemsArrayReceiver>)dataHandler;
{
    BOOL loggedIn=[[NSUserDefaults standardUserDefaults] boolForKey:@"isLoggedIn"];
    KeychainItemWrapper *myKeyChain=[[KeychainItemWrapper alloc] initWithIdentifier:@"sessionID" accessGroup:nil];
    _sessionID=[myKeyChain objectForKey:kSecValueData];
    
    NSDictionary *queryParams = @{APIKeyParameterName : [MovieAppConfiguration getApiKey],
                                  SessionIDParameterName: _sessionID,
                                  PageQueryParameterName: [NSNumber numberWithUnsignedInteger:pageNumber]};
    NSString *subpath=[[AccountDetailsSubpath stringByAppendingString:FavoriteSubpath] stringByAppendingString:mediaType==MovieType ? @"/movies" : @"/tv" ];
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
-(void)getWatchlistOfType:(MediaType)mediaType pageNumber:(NSUInteger)pageNumber returnTo:(id<ItemsArrayReceiver>)dataHandler;
{
    NSDictionary *queryParams = @{APIKeyParameterName : [MovieAppConfiguration getApiKey],
                                  SessionIDParameterName: _sessionID,
                                  PageQueryParameterName: [NSNumber numberWithUnsignedInteger:pageNumber]};
    NSString *subpath=[[AccountDetailsSubpath stringByAppendingString:WatchlistSubpath] stringByAppendingString:mediaType==MovieType ? @"/movies" : @"/tv" ];
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

-(void)getRatedTVEventsOfType:(MediaType)mediaType pageNumber:(NSUInteger)pageNumber returnTo:(id<ItemsArrayReceiver>)dataHandler{
    
    NSDictionary *queryParams = @{APIKeyParameterName : [MovieAppConfiguration getApiKey],
                                  SessionIDParameterName: _sessionID,
                                  PageQueryParameterName: [NSNumber numberWithUnsignedInteger:pageNumber]};
    NSString *subpath=[[AccountDetailsSubpath stringByAppendingString:RatedSubpath] stringByAppendingString:mediaType==MovieType ? @"/movies" : @"/tv" ];
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

+(NSArray *)getCriteriaForSorting{
    return @[@"/popular",@"/latest",@"/top_rated",@"/airing_today",@"/on_the_air"];
}

+(NSString *)getSubpathForClass:(Class)class{
    return (class == [Movie class]) ? MovieDetailsSubpath : TVShowDetailsSubpath;
}

-(void)addResponseDescriptorWithMapping:(RKObjectMapping *)mapping pathPattern:(NSString *)pathPattern keyPath:(NSString *)keyPath forHttpMethod:(HTTPMethod)method{
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:mapping
                                                 method:method==GET ? RKRequestMethodGET : RKRequestMethodPOST
                                            pathPattern:pathPattern
                                                keyPath:keyPath
                                            statusCodes:[NSIndexSet indexSetWithIndex:method==GET ? 200 : 201]];
    
    [objectManager addResponseDescriptor:responseDescriptor];
}

-(void)cancelAllRequests{
    [[objectManager operationQueue] cancelAllOperations];
}


//login
-(void)loginWithLoginRequest:(LoginRequest *)loginData delegate:(id<LoginManagerDelegate>)delegate{
    _loginHandler=delegate;
    [[LoginManager alloc] loginWithLoginRequest:loginData delegate:delegate];
    
}
//login manager delegate methods

-(void)loginSucceededWithSessionID:(NSString *)sessionID{
    _sessionID=sessionID;
    //[_loginHandler loginSucceededWithSessionID:sessionID];
}
-(void)loginFailedWithError:(NSError *)error{
    [_loginHandler loginFailedWithError:error];
}

//POST methods

-(void)rateTVEventWithID:(NSUInteger)tvEventID rating:(CGFloat)rating mediaType:(MediaType)mediaType{
    NSMutableDictionary *postObject=[NSMutableDictionary dictionaryWithDictionary:@{ValueParameterName : [NSNumber numberWithFloat:rating]}];
    
    RKObjectMapping *postObjectMapping=[RKObjectMapping requestMapping];
    [postObjectMapping addAttributeMappingsFromDictionary:@{@"value":@"value"}];
    
    RKRequestDescriptor *postRequestDescriptor=[RKRequestDescriptor requestDescriptorWithMapping:postObjectMapping objectClass:[NSMutableDictionary class] rootKeyPath:nil method:RKRequestMethodAny];
    [[RKObjectManager sharedManager] addRequestDescriptor:postRequestDescriptor];
    NSString *subpath=mediaType==MovieType ? MovieDetailsSubpath : TVShowDetailsSubpath;
    subpath=[subpath stringByAppendingString:[NSString stringWithFormat:@"/%d/rating", (int)tvEventID]];
    subpath=[[subpath stringByAppendingString:@"?api_key="] stringByAppendingString:[MovieAppConfiguration getApiKey]];
    subpath=[[subpath stringByAppendingString:@"&session_id="] stringByAppendingString:_sessionID];
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    
    [[RKObjectManager sharedManager] postObject:postObject path:subpath parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        //missing handling
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        //missing handling
    }];
}

-(void)favoriteTVEventWithID:(NSUInteger)tvEventID mediaType:(MediaType)mediaType remove:(BOOL)shouldRemove{
    FavoritePostObject *postObject=[[FavoritePostObject alloc] initWithMediaID:tvEventID mediaType:mediaType status:!shouldRemove];
    
    RKObjectMapping *postObjectMapping=[RKObjectMapping requestMapping];
    [postObjectMapping addAttributeMappingsFromDictionary:[FavoritePostObject propertiesMapping]];
    
    RKRequestDescriptor *postRequestDescriptor=[RKRequestDescriptor requestDescriptorWithMapping:[postObjectMapping inverseMapping] objectClass:[FavoritePostObject class] rootKeyPath:nil method:RKRequestMethodAny];
    [[RKObjectManager sharedManager] addRequestDescriptor:postRequestDescriptor];
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];

    NSString *subpath=[AccountDetailsSubpath stringByAppendingString:FavoriteSubpath];
    subpath=[[subpath stringByAppendingString:@"?api_key="] stringByAppendingString:[MovieAppConfiguration getApiKey]];
    subpath=[[subpath stringByAppendingString:@"&session_id="] stringByAppendingString:_sessionID];
    
    [[RKObjectManager sharedManager] postObject:postObject path:subpath parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        //missing handling

    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        //missing handling
    }];
}

-(void)addToWatchlistTVEventWithID:(NSUInteger)tvEventID mediaType:(MediaType)mediaType remove:(BOOL)shouldRemove{
    WatchlistPostObject *postObject=[[WatchlistPostObject alloc] initWithMediaID:tvEventID mediaType:mediaType status:!shouldRemove];
    
    RKObjectMapping *postObjectMapping=[RKObjectMapping requestMapping];
    [postObjectMapping addAttributeMappingsFromDictionary:[WatchlistPostObject propertiesMapping]];
    
    RKRequestDescriptor *postRequestDescriptor=[RKRequestDescriptor requestDescriptorWithMapping:[postObjectMapping inverseMapping] objectClass:[WatchlistPostObject class] rootKeyPath:nil method:RKRequestMethodAny];
    [[RKObjectManager sharedManager] addRequestDescriptor:postRequestDescriptor];
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    
    NSString *subpath=[AccountDetailsSubpath stringByAppendingString:WatchlistSubpath];
    subpath=[[subpath stringByAppendingString:@"?api_key="] stringByAppendingString:[MovieAppConfiguration getApiKey]];
    subpath=[[subpath stringByAppendingString:@"&session_id="] stringByAppendingString:_sessionID];
    
    [[RKObjectManager sharedManager] postObject:postObject path:subpath parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        //missing handling
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        //missing handling
    }];
}
@end
