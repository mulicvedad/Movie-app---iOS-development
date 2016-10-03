#import "FeedDownloader.h"
#import "ItemsArrayReceiver.h"
#import "FeedXmlParser.h"

@interface FeedDownloader ()
{
    id<ItemsArrayReceiver> _delegate;
    FeedXmlParser *parser;
}

@end

@implementation FeedDownloader

//making connection between our downloader and caller
- (void)downloadNewsFromFeed:(NSURL *)feedUrl andReturnTo:(id<ItemsArrayReceiver>)dataHandler
{
    _delegate=dataHandler;
    
    NSURLSession *session=[NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask= [session dataTaskWithURL:feedUrl completionHandler:
                                     ^(NSData *data, NSURLResponse * response, NSError *eror)
                                      {
                                           parser=[FeedXmlParser alloc];
                                          [parser parseXmlFromData:data returnToHandler:_delegate];
                                      } ];
    
    [dataTask resume];
    

}
@end
