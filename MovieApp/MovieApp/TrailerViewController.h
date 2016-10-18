#import <UIKit/UIKit.h>
#import "TVEvent.h"
#import "YTPlayerView.h"
#import "ItemsArrayReceiver.h"
#import "Video.h"

@interface TrailerViewController : UIViewController <ItemsArrayReceiver>

@property (nonatomic, strong) TVEvent *tvEvent;
@property (nonatomic, strong) Video *video;
@property (weak, nonatomic) IBOutlet YTPlayerView *youtubePlayerView;

@property (weak, nonatomic) IBOutlet UILabel *videoNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end
