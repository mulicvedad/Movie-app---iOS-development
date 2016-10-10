#import "DataProviderService.h"
#import "Movie.h"
#import "MovieAppConfiguration.h"
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

#define API_KEY_PARAMETER_NAME @"api_key"
#define APPEND_PARAMETER_NAME @"append_to_response"
#define APPEND_PARAMETER_VALUE @"credits"
#define TYPE_KEY @"type"
#define SORT_BY_PARAMETER_NAME @"sort_by"
#define CRITERION_KEY_NAME @"criterion"
#define MOVIE_SUBPATH @"/3/movie"
#define TVSHOW_SUBPATH @"/3/tv"
#define RESULTS_PATH @"results"
#define DISCOVER_SUBPATH_MOVIE @"/3/discover/movie"
#define DISCOVER_SUBPATH_TVSHOW @"/3/discover/tv"
#define LATEST_MOVIES @"/now_playing"
#define LATEST_TVSHOWS @"/on_the_air"
#define POPULARITY_CRITERION_VALUE @"popularity.desc"
#define RELEASE_DATE_CRITERION_VALUE @"release_date.desc"
#define VOTE_COUNT_LOWER_BOUND @1000
#define MOVIE_GENRES_SUBPATH @"3/genre/movie/list"
#define TVSHOW_GENRES_SUBPATH @"3/genre/tv/list"
#define TYPE_DETAILS @"details"
#define TYPE_CREDITS @"credits"
#define GENRES_KEYPATH @"genres"
#define CREW_KEYPATH @"crew"
#define CAST_KEYPATH @"cast"
#define SEASONS_KEYPATH @"seasons"
#define CREDITS_KEYPATH @"/credits"
#define IMAGE_KEYPATH @"images.posters"
#define APPEND_IMAGES_PARAMETER_VALUE @"images"
#define APPENDED_IMAGES_SUBPATH @"/3/:id/:id"

@interface DataProviderService(){
    RKObjectManager *objectManager;
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


    [movieMapping addAttributeMappingsFromDictionary:[Movie propertiesMapping]];
    [tvShowMapping addAttributeMappingsFromDictionary:[TVShow propertiesMapping]];
    [genreMapping addAttributeMappingsFromDictionary:[Genre propertiesMapping]];
    [crewMapping addAttributeMappingsFromDictionary:[CrewMember propertiesMapping]];
    [castMapping addAttributeMappingsFromDictionary:[CastMember propertiesMapping]];
    [movieDetailsMapping addAttributeMappingsFromDictionary:[MovieDetails propertiesMapping]];
    [tvShowDetailsMapping addAttributeMappingsFromDictionary:[TVShowDetails propertiesMapping]];
    [tvShowSeasonMapping addAttributeMappingsFromDictionary:[TvShowSeason propertiesMapping]];
    [imageMapping addAttributeMappingsFromDictionary:[Image propertiesMapping]];


    pathPattern=[subpathForMovies stringByAppendingString:@"/:id"];
    [self addResponseDescriptorWithMapping:movieMapping pathPattern:pathPattern keyPath:RESULTS_PATH];
    
    pathPattern=[subpathForTvShows stringByAppendingString:@"/:id"];
    [self addResponseDescriptorWithMapping:tvShowMapping pathPattern:pathPattern keyPath:RESULTS_PATH];

    
    [self addResponseDescriptorWithMapping:movieMapping pathPattern:DISCOVER_SUBPATH_MOVIE keyPath:RESULTS_PATH];
    [self addResponseDescriptorWithMapping:tvShowMapping pathPattern:DISCOVER_SUBPATH_TVSHOW keyPath:RESULTS_PATH];
    [self addResponseDescriptorWithMapping:genreMapping pathPattern:nil keyPath:GENRES_KEYPATH];
    [self addResponseDescriptorWithMapping:movieDetailsMapping pathPattern:[MOVIE_SUBPATH stringByAppendingString:@"/:id"] keyPath:@""];
    [self addResponseDescriptorWithMapping:tvShowDetailsMapping pathPattern:[TVSHOW_SUBPATH stringByAppendingString:@"/:id"] keyPath:@""];
    [self addResponseDescriptorWithMapping:crewMapping pathPattern:nil keyPath:CREW_KEYPATH];
    [self addResponseDescriptorWithMapping:castMapping pathPattern:nil keyPath:CAST_KEYPATH];
    [self addResponseDescriptorWithMapping:tvShowSeasonMapping pathPattern:[TVSHOW_SUBPATH stringByAppendingString:@"/:id"] keyPath:SEASONS_KEYPATH];
    [self addResponseDescriptorWithMapping:imageMapping pathPattern:APPENDED_IMAGES_SUBPATH keyPath:IMAGE_KEYPATH];
}

-(void)getTvEventsByCriterion:(Criterion)criterion returnToHandler:(id<ItemsArrayReceiver>)delegate{
    
    Class currentClass=((TVEventsViewController *)delegate).isMovieViewController ? [Movie class] : [TVShow class];
    NSString *criterionForSorting;
    if(criterion==LATEST){
        criterionForSorting=(currentClass == [Movie class]) ? LATEST_MOVIES : LATEST_TVSHOWS;
    }
    else{
        criterionForSorting=[DataProviderService getCriteriaForSorting][criterion];
    }
    NSString *subpath=[[DataProviderService getSubpathForClass:currentClass] stringByAppendingString:criterionForSorting];
    
    NSDictionary *queryParams = @{API_KEY_PARAMETER_NAME: [MovieAppConfiguration getApiKey]};
        [[RKObjectManager sharedManager] getObjectsAtPath:subpath
                                               parameters:queryParams
                                                  success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                      NSArray *tvEvents = [NSMutableArray arrayWithArray: mappingResult.array];
                                                      
                                                      [delegate updateReceiverWithNewData:tvEvents info:@{CRITERION_KEY_NAME:[DataProviderService getCriteriaForSorting][criterion]}];
                                                      
                                                  }
                                                  failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                      //MISSING ERROR HANDLING
                                                      NSLog(@"Error: %@", error);
                                                  }];

    
}

-(void)getGenresForTvEvent:(Class)class ReturnTo:(id<ItemsArrayReceiver>)delegate{
    
    NSDictionary *queryParams = @{API_KEY_PARAMETER_NAME: [MovieAppConfiguration getApiKey]};
    
    [[RKObjectManager sharedManager] getObjectsAtPath:(class == [Movie class]) ? MOVIE_GENRES_SUBPATH : TVSHOW_GENRES_SUBPATH
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                    [delegate updateReceiverWithNewData:mappingResult.array info:@{TYPE_KEY: [class getClassName]}];
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  //MISSING ERROR HANDLING
                                                  NSLog(@"Error: %@", error);
                                              }];

}

-(void)getDetailsForTvEvent:(TVEvent *)tvEvent returnTo:(id)dataHandler{
    NSDictionary *queryParams = @{API_KEY_PARAMETER_NAME : [MovieAppConfiguration getApiKey],
                                  APPEND_PARAMETER_NAME : APPEND_IMAGES_PARAMETER_VALUE};
    NSString *subpath;
    if([tvEvent isKindOfClass:[Movie class]]){
        subpath=MOVIE_SUBPATH;
    }
    else{
        subpath=TVSHOW_SUBPATH;
    }
    
    subpath=[subpath stringByAppendingString:[NSString stringWithFormat:@"/%lu",tvEvent.id]];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:subpath
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  [dataHandler updateReceiverWithNewData:mappingResult.array info:@{TYPE_KEY:TYPE_DETAILS}];
                                                
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  //MISSING ERROR HANDLING
                                                  NSLog(@"Error: %@", error);
                                              }];

    
}

-(void)getCreditsForTvEvent:(TVEvent *)tvEvent returnTo:(id)dataHandler{
    NSDictionary *queryParams = @{API_KEY_PARAMETER_NAME: [MovieAppConfiguration getApiKey]};
    NSString *subpath;
    if([tvEvent isKindOfClass:[Movie class]]){
        subpath=MOVIE_SUBPATH;
    }
    else{
        subpath=TVSHOW_SUBPATH;
    }
    
    subpath=[[subpath stringByAppendingString:[NSString stringWithFormat:@"/%lu",tvEvent.id]] stringByAppendingString:CREDITS_KEYPATH];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:subpath
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  [dataHandler updateReceiverWithNewData:mappingResult.array info:@{TYPE_KEY:TYPE_CREDITS}];
                                                  
                                                  
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
    return (class == [Movie class]) ? MOVIE_SUBPATH : TVSHOW_SUBPATH ;
}

-(void)addResponseDescriptorWithMapping:(RKObjectMapping *)mapping pathPattern:(NSString *)pathPattern keyPath:(NSString *)keyPath{
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:mapping
                                                 method:RKRequestMethodGET
                                            pathPattern:pathPattern
                                                keyPath:keyPath
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor:responseDescriptor];
}


@end
