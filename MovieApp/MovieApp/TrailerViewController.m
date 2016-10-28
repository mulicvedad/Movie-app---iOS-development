#import "TrailerViewController.h"

@implementation TrailerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

-(void)setup{
    self.videoNameLabel.text=[@"Trailer - " stringByAppendingString:self.tvEvent.title];
    self.descriptionLabel.text=self.tvEvent.overview;
    [self.youtubePlayerView loadWithVideoId:self.video.key];
}


@end
