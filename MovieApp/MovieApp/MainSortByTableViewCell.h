#import <UIKit/UIKit.h>

@interface MainSortByTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *sortCriterionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

+(NSString *)cellIdentifier;
+(NSString *)cellIClassName;

-(void)setupWithCriterion:(NSString *)criterion isDropDownActive:(BOOL)dropDownStateIsActive;
@end
