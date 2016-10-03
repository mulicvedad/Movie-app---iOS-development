#import <Foundation/Foundation.h>
#import "NewFeedsItem.h"
#import "ItemsArrayReceiver.h"


@interface FeedDownloader : NSObject <NSURLSessionDataDelegate,NSURLSessionDelegate>

- (void)downloadNewsFromFeed:(NSURL *)feedUrl andReturnTo:(id<ItemsArrayReceiver>)dataHandler;

@end
