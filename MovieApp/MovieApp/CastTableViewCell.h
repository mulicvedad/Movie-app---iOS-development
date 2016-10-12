//
//  CastTableViewCell.h
//  MovieApp
//
//  Created by user on 11/10/16.
//  Copyright © 2016 internshipABH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CastTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIStackView *castStackView;

-(void)setupWithImageUrls:(NSArray *)urls correspondingNames:(NSArray *)names roles:(NSArray *)roles;
+(NSString *)cellIdentifier;
+(NSString *)cellIClassName;

@end
