//
//  MoviesCollectionViewCell.m
//  MovieApp
//
//  Created by user on 28/09/16.
//  Copyright © 2016 internshipABH. All rights reserved.
//

#import "MoviesCollectionViewCell.h"

@implementation MoviesCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(UIEdgeInsets)cellInsets{
    return UIEdgeInsetsMake(2, 2, 2, 2);
}

+(CGFloat)cellHeight{
    return 254;
}

@end
