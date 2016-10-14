#import <UIKit/UIKit.h>
#import "TVShowEpisode.h"
#import "ItemsArrayReceiver.h"
#import "Video.h"

@interface EpisodeDetailsTableViewController : UITableViewController <ItemsArrayReceiver>

@property (nonatomic) NSUInteger tvShowID;
@property(nonatomic, strong) TVShowEpisode *episode;
@property(nonatomic, strong) Video *trailer;

@end
