#import <UIKit/UIKit.h>

@interface TVEventCreditsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *directorLabelLeft;
@property (weak, nonatomic) IBOutlet UILabel *directrorLabelRight;
@property (weak, nonatomic) IBOutlet UILabel *writersLabelLeft;
@property (weak, nonatomic) IBOutlet UILabel *writersLabelRight;
@property (weak, nonatomic) IBOutlet UILabel *starsLabelLeft;
@property (weak, nonatomic) IBOutlet UILabel *starsLabelRight;


-(void)setupWithDirector:(NSString *)director writers:(NSString *)writers stars:(NSString *)stars;
+(NSString *)cellIdentifier;
+(NSString *)cellIClassName;

@end
