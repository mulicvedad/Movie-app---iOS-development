#import "FeedDownloader.h"
#import "FeedXmlParser.h"

@implementation FeedDownloader

//making connection between our downloader and caller
- (void)downloadNewsFromFeed:(NSURL *)feedUrl andReturnTo:(id<ItemsArrayReceiver>)dataHandler
{
    NSURLSession *session=[NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask= [session dataTaskWithURL:feedUrl completionHandler:
                                     ^(NSData *data, NSURLResponse * response, NSError *eror)
                                      {
                                          //MISSING ERROR HANDLING
                                          [[[FeedXmlParser alloc] init] parseXmlFromData:data returnToHandler:dataHandler];
                                      } ];
    [dataTask resume];
}
@end
