#import <UIKit/UIKit.h>
#import <YTPlayerView.h>

@interface TrailerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *viewForGradient;
@property (weak, nonatomic) IBOutlet UIImageView *trailerImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
+(NSString *)cellIdentifier;
+(NSString *)cellIClassName;
-(void)setGradientLayer;
-(void)setupCellWithTitle:(NSString *)originalTitle imageUrl:(NSURL *)imageUrl releaseYear:(NSString *)releaseYear;

@end
