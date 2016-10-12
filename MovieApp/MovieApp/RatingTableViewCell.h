#import <UIKit/UIKit.h>

@interface RatingTableViewCell : UITableViewCell

-(void)setupWithRating:(CGFloat)rating;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
+(NSString *)cellIdentifier;
+(NSString *)cellIClassName;
@end
