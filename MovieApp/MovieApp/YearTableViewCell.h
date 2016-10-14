#import <UIKit/UIKit.h>

@interface YearTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;

+(NSString *)cellIdentifier;
+(NSString *)cellIClassName;

@end
