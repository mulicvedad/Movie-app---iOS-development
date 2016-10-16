#import <UIKit/UIKit.h>

@interface BasicEpisodeInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *airDateLabel;

+(NSString *)cellIdentifier;
+(NSString *)cellIClassName;
-(void)setupWithTitle:(NSString *)title airDate:(NSString *)dateAsString;
@end
