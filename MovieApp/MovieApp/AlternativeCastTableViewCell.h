

#import <UIKit/UIKit.h>

@interface AlternativeCastTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImageView;
@property (weak, nonatomic) IBOutlet UIImageView *fourthImageView;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstRoleLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondRoleLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdRoleLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourthNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourthRoleLabel;

+(NSString *)cellIdentifier;
+(NSString *)cellIClassName;

-(void)setupWithImageUrls:(NSArray *)urls correspondingNames:(NSArray *)names roles:(NSArray *)roles;

@end
