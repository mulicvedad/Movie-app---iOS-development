#import <UIKit/UIKit.h>
#import "AddTVEventToCollectionDelegate.h"

@interface RatingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateThisLabel;
+(NSString *)cellIdentifier;
+(NSString *)cellIClassName;
-(void)hideRating;
-(void)setupWithRating:(CGFloat)rating delegate:(id<AddTVEventToCollectionDelegate>)delegate;
@end
