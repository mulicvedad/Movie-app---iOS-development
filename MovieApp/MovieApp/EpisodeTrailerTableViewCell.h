#import <UIKit/UIKit.h>
#import "Video.h"
#import "YTPlayerView.h"

@interface EpisodeTrailerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet YTPlayerView *videoPlayer;

+(NSString *)cellIdentifier;
+(NSString *)cellIClassName;
-(void)setupWithVideo:(Video *)video;
@end
