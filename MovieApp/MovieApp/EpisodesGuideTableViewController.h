#import <UIKit/UIKit.h>
#import "ItemsArrayReceiver.h"
#import "TVShow.h"

@interface EpisodesGuideTableViewController : UITableViewController <ItemsArrayReceiver, UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) TVShow *tvShow;
@property (nonatomic, strong) NSArray *seasons;
@end
