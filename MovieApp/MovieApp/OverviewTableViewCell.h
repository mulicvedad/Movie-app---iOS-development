#import <UIKit/UIKit.h>

@interface OverviewTableViewCell : UITableViewCell

-(void)setupWithOverview:(NSString *)overview;
@property (weak, nonatomic) IBOutlet UILabel *overviewLabel;
+(NSString *)cellIdentifier;
+(NSString *)cellIClassName;

@end
