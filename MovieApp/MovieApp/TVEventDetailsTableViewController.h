#import <UIKit/UIKit.h>
#import "TVEvent.h"
#import "ItemsArrayReceiver.h"
#import "SeasonsTableViewCellDelegate.h"
#import "ShowTrailerDelegate.h"

@interface TVEventDetailsTableViewController : UITableViewController <ItemsArrayReceiver, SeasonsTableViewCellDelegate, ShowTrailerDelegate>
-(void)setMainTvEvent:(TVEvent *)tvEvent;
@end
