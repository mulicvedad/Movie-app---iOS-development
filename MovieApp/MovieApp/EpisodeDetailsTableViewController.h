#import <UIKit/UIKit.h>
#import "TVShowEpisode.h"
#import "ItemsArrayReceiver.h"
#import "Video.h"
#import "AddTVEventToCollectionDelegate.h"

@interface EpisodeDetailsTableViewController : UITableViewController <ItemsArrayReceiver, UICollectionViewDelegate, UICollectionViewDataSource, AddTVEventToCollectionDelegate>

@property (nonatomic) NSUInteger tvShowID;
@property(nonatomic, strong) TVShowEpisode *episode;
@property(nonatomic, strong) Video *trailer;

@end
