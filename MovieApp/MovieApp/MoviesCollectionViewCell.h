//
//  MoviesCollectionViewCell.h
//  MovieApp
//
//  Created by user on 28/09/16.
//  Copyright © 2016 internshipABH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoviesCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseDateLabel;

+(UIEdgeInsets)cellInsets;
+(CGFloat)cellHeight;
+(NSString *)cellIdentifier;

@end
