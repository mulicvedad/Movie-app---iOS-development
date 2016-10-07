#import "DataProviderService.h"
#import "Movie.h"
#import "MovieAppConfiguration.h"
#import "ItemsArrayReceiver.h"
#import <UIKit/UIKit.h>
#import <RestKit.h>
#import "TVEventsViewController.h"
#import "TVShow.h"
#import "Genre.h"

#define API_KEY_PARAMETER_NAME @"api_key"
#define TYPE_KEY @"type"
#define SORT_BY_PARAMETER_NAME @"sort_by"
#define CRITERION_KEY_NAME @"criterion"
#define MOVIE_SUBPATH @"/3/movie"
#define TVSHOW_SUBPATH @"/3/tv"
#define RESULTS_PATH @"results"
#define DISCOVER_SUBPATH_MOVIE @"/3/discover/movie"
#define DISCOVER_SUBPATH_TVSHOW @"/3/discover/tv"
#define LATEST_MOVIES @"release_date.desc"
#define LATEST_TVSHOWS @"first_air_date.desc"
#define POPULARITY_CRITERION_VALUE @"popularity.desc"
#define RELEASE_DATE_CRITERION @"release_date.desc"
#define VOTE_COUNT_LOWER_BOUND @1000
#define MOVIE_GENRES_SUBPATH @"3/genre/movie/list"
#define TVSHOW_GENRES_SUBPATH @"3/genre/tv/list"


@interface DataProviderService(){
    NSMutableArray *tvEvents;
    id<ItemsArrayReceiver> dataHandler;
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
    
    RKObjectMapping *mappingForMovie = [RKObjectMapping mappingForClass:[Movie class]];
    RKObjectMapping *mappingForTvShow = [RKObjectMapping mappingForClass:[TVShow class]];
    RKObjectMapping *mappingForGenres = [RKObjectMapping mappingForClass:[Genre class]];

    [mappingForMovie addAttributeMappingsFromDictionary:[Movie propertiesMapping]];
    [mappingForTvShow addAttributeMappingsFromDictionary:[TVShow propertiesMapping]];
    [mappingForGenres addAttributeMappingsFromDictionary:[Genre propertiesMapping]];
                                 
    NSMutableArray *responseDescriptors=[[NSMutableArray alloc] init];
                                 
    for(NSString *tailPath in [DataProviderService getCriteriaForSorting]){
        NSString *keyPath=[subpathForMovies stringByAppendingString:tailPath];
        
        RKResponseDescriptor *responseDescriptorForMovie =
        [RKResponseDescriptor responseDescriptorWithMapping:mappingForMovie
                                                     method:RKRequestMethodGET
                                                pathPattern:keyPath
                                                    keyPath:RESULTS_PATH
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
     
        [responseDescriptors addObject:responseDescriptorForMovie];
        if([responseDescriptors count]==3){
            break;
        }
    }
    
    for(NSString *tailPath in [DataProviderService getCriteriaForSorting]){
        NSString *keyPath=[subpathForTvShows stringByAppendingString:tailPath];

        RKResponseDescriptor *responseDescriptorForTvShow =
        [RKResponseDescriptor responseDescriptorWithMapping:mappingForTvShow
                                                     method:RKRequestMethodGET
                                                pathPattern:keyPath
                                                    keyPath:RESULTS_PATH
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]];
        
        [responseDescriptors addObject:responseDescriptorForTvShow];
    }
    
    RKResponseDescriptor *responseDescriptorForLatestMovies =
    [RKResponseDescriptor responseDescriptorWithMapping:mappingForMovie
                                                 method:RKRequestMethodGET
                                            pathPattern:DISCOVER_SUBPATH_MOVIE
                                                keyPath:RESULTS_PATH
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [responseDescriptors addObject:responseDescriptorForLatestMovies];
    
    
    RKResponseDescriptor *responseDescriptorForLatestTvShows =
    [RKResponseDescriptor responseDescriptorWithMapping:mappingForTvShow
                                                 method:RKRequestMethodGET
                                            pathPattern:DISCOVER_SUBPATH_TVSHOW
                                                keyPath:RESULTS_PATH
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [responseDescriptors addObject:responseDescriptorForLatestTvShows];
    
    RKResponseDescriptor *responseDescriptorForMovieGenres =
    [RKResponseDescriptor responseDescriptorWithMapping:mappingForGenres
                                                 method:RKRequestMethodGET
                                            pathPattern:nil
                                                keyPath:@"genres"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [responseDescriptors addObject:responseDescriptorForMovieGenres];
    
    RKResponseDescriptor *responseDescriptorForTVShowGenres =
    [RKResponseDescriptor responseDescriptorWithMapping:mappingForGenres
                                                 method:RKRequestMethodGET
                                            pathPattern:nil
                                                keyPath:@"genres"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [responseDescriptors addObject:responseDescriptorForTVShowGenres];
    
    [objectManager addResponseDescriptorsFromArray:responseDescriptors];
}

-(void)getTvEventsByCriterion:(Criterion)criterion returnToHandler:(id<ItemsArrayReceiver>)delegate{
    
    Class currentClass=((TVEventsViewController *)delegate).isMovieViewController ? [Movie class] : [TVShow class];
    
    NSString *subpath=[[DataProviderService getSubpathForClass:currentClass] stringByAppendingString:[DataProviderService getCriteriaForSorting][criterion]];
    
    NSDictionary *queryParams = @{API_KEY_PARAMETER_NAME: [MovieAppConfiguration getApiKey]};
    if(criterion!=LATEST)
    {
        [[RKObjectManager sharedManager] getObjectsAtPath:subpath
                                               parameters:queryParams
                                                  success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                      tvEvents = [NSMutableArray arrayWithArray: mappingResult.array];
                                                      
                                                      [delegate updateReceiverWithNewData:tvEvents info:@{CRITERION_KEY_NAME:[DataProviderService getCriteriaForSorting][criterion]}];
                                                      
                                                  }
                                                  failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                      //MISSING ERROR HANDLING
                                                      NSLog(@"Error: %@", error);
                                                  }];

    }
    else{
        //SPECIAL CASE: latest tv events
        NSDictionary *discoverQueryParams = @{API_KEY_PARAMETER_NAME: [MovieAppConfiguration getApiKey],
                                              SORT_BY_PARAMETER_NAME:(currentClass == [Movie class]) ? LATEST_MOVIES : LATEST_TVSHOWS};
        [[RKObjectManager sharedManager] getObjectsAtPath:(currentClass == [Movie class]) ? DISCOVER_SUBPATH_MOVIE : DISCOVER_SUBPATH_TVSHOW
                                               parameters:discoverQueryParams
                                                  success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                      tvEvents = [NSMutableArray arrayWithArray: mappingResult.array];
                                                      [delegate updateReceiverWithNewData:tvEvents info:@{CRITERION_KEY_NAME:[DataProviderService getCriteriaForSorting][criterion]}];
                                                      
                                                  }
                                                  failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                      //MISSING ERROR HANDLING
                                                      NSLog(@"Error: %@", error);
                                                  }];
        
    }
    
}

-(void)getGenresForTvEvent:(Class)class ReturnTo:(id<ItemsArrayReceiver>)delegate{
    
    NSDictionary *queryParams = @{API_KEY_PARAMETER_NAME: [MovieAppConfiguration getApiKey]};
    
    [[RKObjectManager sharedManager] getObjectsAtPath:(class == [Movie class]) ? MOVIE_GENRES_SUBPATH : TVSHOW_GENRES_SUBPATH
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                    [delegate updateReceiverWithNewData: [NSMutableArray arrayWithArray: mappingResult.array] info:@{TYPE_KEY: [class getClassName]}];
                                                  
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


@end
