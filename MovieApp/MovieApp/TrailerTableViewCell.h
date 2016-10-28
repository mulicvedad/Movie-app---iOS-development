#import <UIKit/UIKit.h>
#import <YTPlayerView.h>
#import "ShowTrailerDelegate.h"
#import "TVEvent.h"

@interface TrailerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *viewForGradient;
@property (weak, nonatomic) IBOutlet UIImageView *trailerImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (strong, nonatomic) CAGradientLayer *myGradientLayer;

+(NSString *)cellIdentifier;
+(NSString *)cellIClassName;
-(void)setGradientLayer;
-(void)setupCellWithTitle:(NSString *)originalTitle imageUrl:(NSURL *)imageUrl releaseYear:(NSString *)releaseYear;
-(void)setupWithTVEvent:(TVEvent *)tvEvent;
-(void)setDelegate:(id<ShowTrailerDelegate>)delegate;

@end
