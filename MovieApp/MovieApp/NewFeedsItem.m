//
//  NewFeedsItem.m
//  MovieApp
//
//  Created by user on 22/09/16.
//  Copyright © 2016 internshipABH. All rights reserved.
//

#import "NewFeedsItem.h"

@implementation NewFeedsItem

@synthesize headline, text, webPage;

- (instancetype)initWithHeadline:(NSString *)pheadline andWithText:(NSString *)ptext andWithWebPage:(NSString *)pwebPage
{
    self = [super init];
    headline=pheadline;
    text=ptext;
    webPage=pwebPage;
    return self;
}

@end
