//
//  FeedTableViewCell.m
//  MovieApp
//
//  Created by user on 23/09/16.
//  Copyright © 2016 internshipABH. All rights reserved.
//

#import "FeedTableViewCell.h"

@implementation FeedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)cellHeight{
    return 200;
}

+ (NSString *)cellIdentifier{
    return @"feedCell";
}

@end
