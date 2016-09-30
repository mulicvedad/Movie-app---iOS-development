//
//  FeedDownloader.h
//  MovieApp
//
//  Created by user on 26/09/16.
//  Copyright © 2016 internshipABH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewFeedsItem.h"

@protocol FeedDataReceiver <NSObject>

@required
-(void)updateViewWithNewData:(NSMutableArray *)feedItemsArray;

@end

@interface FeedDownloader : NSObject <NSXMLParserDelegate, NSURLSessionDataDelegate,NSURLSessionDelegate>

- (void)downloadNewsFromFeed:(NSURL *)feedUrl andReturnTo:(id)dataHandler;

@end
