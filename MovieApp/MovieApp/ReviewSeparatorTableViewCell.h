#import <UIKit/UIKit.h>

@interface ReviewSeparatorTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *lineView;
-(void)setupForCastMemberDetails;
+(NSString *)cellIdentifier;
+(NSString *)cellIClassName;

@end
