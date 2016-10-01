//
//  CustomTableViewCell.h
//  MovieApp
//
//  Created by user on 26/09/16.
//  Copyright © 2016 internshipABH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell

@property (nonatomic, readonly) CGFloat height;

+ (CGFloat)cellHeight;
+ (NSString *)cellIdentifier;
+(NSString *)cellViewClassName;

@end
