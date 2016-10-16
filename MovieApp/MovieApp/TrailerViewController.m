#import "TrailerViewController.h"
#import "DataProviderService.h"
#import "Video.h"

@interface TrailerViewController (){
    NSArray *_videos;
}

@end

@implementation TrailerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[DataProviderService sharedDataProviderService] getVideosForTvEventID:_tvEvent.id returnTo:self];
    [self setup];
}

-(void)setup{
    self.videoNameLabel.text=[@"Trailer - " stringByAppendingString:self.tvEvent.title];
    self.descriptionLabel.text=self.tvEvent.overview;
}

-(void)updateReceiverWithNewData:(NSArray *)customItemsArray info:(NSDictionary *)info{
    _videos=customItemsArray;
    if([_videos count]>0){
        for(Video *video in _videos){
            if([video.site isEqualToString:@"YouTube"]){
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [self.youtubePlayerView loadWithVideoId:video.key];

                });
                break;
            }
        }
    }
}

@end
