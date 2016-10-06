#import <UIKit/UIKit.h>
#import "TVEvent.h"

@interface TVEventsCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseDateLabel;
@property (weak, nonatomic) IBOutlet UIView *viewForGradient;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *genreLabel;

+(UIEdgeInsets)cellInsets;
+(CGFloat)cellHeight;
+(NSString *)cellIdentifier;
+(NSString *)cellViewClassName;
-(void)setupWithTvEvent:(TVEvent *)tvEvent;
@end
