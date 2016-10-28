#import <UIKit/UIKit.h>
#import "TVEvent.h"
#import "ItemsArrayReceiver.h"
#import "SeasonsTableViewCellDelegate.h"

@interface TVEventDetailsTableViewController : UITableViewController <ItemsArrayReceiver, SeasonsTableViewCellDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
-(void)setMainTvEvent:(TVEvent *)tvEvent;
@end
