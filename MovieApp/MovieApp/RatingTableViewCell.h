#import <UIKit/UIKit.h>
#import "AddTVEventToCollectionDelegate.h"

@interface RatingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateThisLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rateThisImageView;
+(NSString *)cellIdentifier;
+(NSString *)cellIClassName;

-(void)setupWithRating:(CGFloat)rating delegate:(id<AddTVEventToCollectionDelegate>)delegate;
@end
