//
//  CustomTableViewCell.m
//  MovieApp
//
//  Created by user on 26/09/16.
//  Copyright © 2016 internshipABH. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

+(CGFloat)cellHeight{
    return 44;
}

+(NSString *)cellIdentifier{
    return nil;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
