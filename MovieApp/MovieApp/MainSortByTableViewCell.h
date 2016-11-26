#import <UIKit/UIKit.h>

@interface MainSortByTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *sortCriterionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UILabel *sortByLabel;

+(NSString *)cellIdentifier;
+(NSString *)cellIClassName;

-(void)setupWithCriterion:(NSString *)criterion isDropDownActive:(BOOL)dropDownStateIsActive isFilterBy:(BOOL)filter;
@end
