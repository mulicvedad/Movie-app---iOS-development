#import <UIKit/UIKit.h>
#import "TVEvent.h"
#import "ItemsArrayReceiver.h"

@interface TVEventDetailsTableViewController : UITableViewController <ItemsArrayReceiver>
-(void)setMainTvEvent:(TVEvent *)tvEvent;
@end
