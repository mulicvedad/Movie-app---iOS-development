#import "MovieDBDownloader.h"
#import "Movie.h"
#import "MovieAppConfiguration.h"
#import "ItemsArrayReceiver.h"
#import <RestKit.h>

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

@implementation MovieDBDownloader

-(void)configure{

    NSString *urlString=[[NSBundle mainBundle] objectForInfoDictionaryKey:@"TheMovieDBBaseUrl"];
    baseURL = [NSURL URLWithString:urlString];
    httpClient = [[AFRKHTTPClient alloc] initWithBaseURL:baseURL];
    
    objectManager = [[RKObjectManager alloc] initWithHTTPClient:httpClient];

    movieMapping = [RKObjectMapping mappingForClass:[Movie class]];
    [movieMapping addAttributeMappingsFromArray:@[@"title",@"poster_path",@"overview"]];
    
    responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:movieMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"/3/discover/movie"
                                                keyPath:@"results"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor:responseDescriptor];
}

-(void)getdMoviesByCriterion:(Criterion)criterion returnToHandler:(id)delegate{
    dataHandler=delegate;
    
    NSDictionary *queryParams = @{@"api_key" : [MovieAppConfiguration getApiKey]};
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/3/discover/movie"
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  movies = [NSMutableArray arrayWithArray: mappingResult.array];
                                                  [dataHandler updateViewWithNewData:movies];
                                                  
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Error: %@", error);
                                              }];
    
}

@end
