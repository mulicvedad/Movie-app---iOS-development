#import <UIKit/UIKit.h>

@interface SortByDropDownTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *sortCriterionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

+(NSString *)cellIdentifier;
+(NSString *)cellIClassName;

-(void)setupWithCriterion:(NSString *)criterion isSelected:(BOOL)selected;
@end
