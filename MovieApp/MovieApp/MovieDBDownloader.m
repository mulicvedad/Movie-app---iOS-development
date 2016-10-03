#import "MovieDBDownloader.h"
#import "Movie.h"
#import "MovieAppConfiguration.h"
#import "ItemsArrayReceiver.h"
#import <RestKit.h>

#define API_KEY_PARAMETER @"api_key"
#define SORT_BY_PARAMETER @"sort_by"
#define VOTE_COUNT_PARAMETER @"vote_count.gte"
#define VOTE_AVERAGE_CRIITERION_VALUE @"vote_average.desc"
#define MOVIE_SUBPATH @"/3/discover/movie"
#define RESULTS_PATH @"results"
#define POPULARITY_CRITERION_VALUE @"popularity.desc"
#define RELEASE_DATE_CRITERION @"release_date.desc"
#define VOTE_COUNT_LOWER_BOUND @1000

@interface MovieDBDownloader(){
    NSMutableArray *movies;
    id<ItemsArrayReceiver> dataHandler;
    NSURL *baseURL;
    AFRKHTTPClient *httpClient;
    RKObjectManager *objectManager;
    RKObjectMapping *movieMapping;
    RKResponseDescriptor *responseDescriptor;
}

@end
NSArray* niz;
@implementation MovieDBDownloader

-(void)configure{

    NSString *urlString=[[NSBundle mainBundle] objectForInfoDictionaryKey:@"TheMovieDBBaseUrl"];
    baseURL = [NSURL URLWithString:urlString];
    httpClient = [[AFRKHTTPClient alloc] initWithBaseURL:baseURL];
    
    objectManager = [[RKObjectManager alloc] initWithHTTPClient:httpClient];

    movieMapping = [RKObjectMapping mappingForClass:[Movie class]];
    [movieMapping addAttributeMappingsFromArray:[Movie getPropertiesNames]];
    
    responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:movieMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:MOVIE_SUBPATH
                                                keyPath:RESULTS_PATH
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor:responseDescriptor];
}

-(void)getdMoviesByCriterion:(Criterion)criterion returnToHandler:(id)delegate{
    dataHandler=delegate;

    NSDictionary *queryParams = @{API_KEY_PARAMETER: [MovieAppConfiguration getApiKey],
                                  SORT_BY_PARAMETER: [MovieDBDownloader getCriterionsForSorting][criterion],
                                  VOTE_COUNT_PARAMETER: VOTE_COUNT_LOWER_BOUND};
    
    [[RKObjectManager sharedManager] getObjectsAtPath:MOVIE_SUBPATH
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  movies = [NSMutableArray arrayWithArray: mappingResult.array];
                                                  [dataHandler updateReceiverWithNewData:movies info:@{@"criterion":[MovieDBDownloader getCriterionsForSorting][criterion]}];
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Error: %@", error);
                                              }];
    
}

+(NSArray *)getCriterionsForSorting{
    return @[@"most_popular",@"top_rated",@"latest"];
}


@end
