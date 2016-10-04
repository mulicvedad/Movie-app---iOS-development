#import <UIKit/UIKit.h>

@interface MoviesCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseDateLabel;
@property (weak, nonatomic) IBOutlet UIView *viewForGradient;
@property (weak, nonatomic) IBOutlet UILabel *starsLabel;

+(UIEdgeInsets)cellInsets;
+(CGFloat)cellHeight;
+(NSString *)cellIdentifier;

@end
