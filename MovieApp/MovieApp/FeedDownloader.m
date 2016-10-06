#import "FeedDownloader.h"
#import "FeedXmlParser.h"

@implementation FeedDownloader

- (void)downloadNewsFromFeed:(NSURL *)feedUrl andReturnTo:(id<ItemsArrayReceiver>)dataHandler
{
    NSURLSession *session=[NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask= [session dataTaskWithURL:feedUrl completionHandler:
                                     ^(NSData *data, NSURLResponse * response, NSError *eror)
                                      {
                                          //MISSING ERROR HANDLING
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              [[[FeedXmlParser alloc] init] parseXmlFromData:data returnToHandler:dataHandler];

                                          });
                                      } ];
    [dataTask resume];
}

@end
