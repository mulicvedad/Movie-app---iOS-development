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

@interface FeedDownloader : NSObject <NSURLConnectionDelegate, NSXMLParserDelegate>

@property (strong, nonatomic) NSURL * feedURL;

- (void)downloadNewsFromFeed:(NSURL *)feedUrl andReturnTo:(id)dataHandler;

@end
