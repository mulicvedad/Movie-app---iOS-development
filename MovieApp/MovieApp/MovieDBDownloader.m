#import "MovieDBDownloader.h"
#import "Movie.h"
#import "MovieAppConfiguration.h"
#import "ItemsArrayReceiver.h"
#import <UIKit/UIKit.h>
#import <RestKit.h>

#define API_KEY_PARAMETER_NAME @"api_key"
#define SORT_BY_PARAMETER_NAME @"sort_by"
#define CRITERION_KEY_NAME @"criterion"
#define VOTE_COUNT_PARAMETER_NAME @"vote_count.gte"
#define VOTE_AVERAGE_CRIITERION_VALUE @"vote_average.desc"
#define MOVIE_SUBPATH @"/3/discover/movie"
#define RESULTS_PATH @"results"
#define POPULARITY_CRITERION_VALUE @"popularity.desc"
#define RELEASE_DATE_CRITERION @"release_date.desc"
#define VOTE_COUNT_LOWER_BOUND @1000

@interface MovieDBDownloader(){
    NSMutableArray *movies;
    id<ItemsArrayReceiver> dataHandler;
    NSURL *apiBaseURL;
    AFRKHTTPClient *httpClient;
    RKObjectManager *objectManager;
    RKObjectMapping *movieMapping;
    RKResponseDescriptor *responseDescriptor;
}

@end

@implementation MovieDBDownloader

-(void)configure{

    NSString *urlString=[[NSBundle mainBundle] objectForInfoDictionaryKey:@"TheMovieDBBaseUrl"];
    apiBaseURL = [NSURL URLWithString:urlString];
    httpClient = [[AFRKHTTPClient alloc] initWithBaseURL:apiBaseURL];
    
    objectManager = [[RKObjectManager alloc] initWithHTTPClient:httpClient];

    movieMapping = [RKObjectMapping mappingForClass:[Movie class]];
    
    [movieMapping addAttributeMappingsFromDictionary:[Movie propertiesMapping]];
    
    responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:movieMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:MOVIE_SUBPATH
                                                keyPath:RESULTS_PATH
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor:responseDescriptor];
}

-(void)getdMoviesByCriterion:(Criterion)criterion returnToHandler:(id<ItemsArrayReceiver>)delegate{
    
    NSDictionary *queryParams = @{API_KEY_PARAMETER_NAME: [MovieAppConfiguration getApiKey],
                                  SORT_BY_PARAMETER_NAME: [MovieDBDownloader getCriteriaForSorting][criterion],
                                  VOTE_COUNT_PARAMETER_NAME: VOTE_COUNT_LOWER_BOUND};
    
    [[RKObjectManager sharedManager] getObjectsAtPath:MOVIE_SUBPATH
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  movies = [NSMutableArray arrayWithArray: mappingResult.array];
                                                  [delegate updateReceiverWithNewData:movies info:@{CRITERION_KEY_NAME:[MovieDBDownloader getCriteriaForSorting][criterion]}];
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  //MISSING ERROR HANDLING
                                                  NSLog(@"Error: %@", error);
                                              }];
    
}

+(NSArray *)getCriteriaForSorting{
    return @[@"popularity.desc",@"release_date.desc",@"vote_average.desc"];
}


@end
