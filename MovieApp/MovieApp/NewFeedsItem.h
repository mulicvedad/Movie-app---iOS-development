//
//  NewFeedsItem.h
//  MovieApp
//
//  Created by user on 22/09/16.
//  Copyright © 2016 internshipABH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewFeedsItem : NSObject

@property (strong, nonatomic) NSString *headline;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *webPage;
//@property (strong, nonatomic) NSDate *dateOfArticle;

- (id)initWithHeadline:(NSString *)pheadline andWithText:(NSString *)ptext andWithWebPage:(NSString *)pwebPage;

@end
