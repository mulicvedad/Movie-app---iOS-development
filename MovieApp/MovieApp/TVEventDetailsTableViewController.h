#import <UIKit/UIKit.h>
#import "TVEvent.h"
#import "ItemsArrayReceiver.h"
#import "SeasonsTableViewCellDelegate.h"
#import "AddTVEventToCollectionDelegate.h"
#import "TVEventsCollectionsStateChangeHandler.h"


@interface TVEventDetailsTableViewController : UITableViewController <ItemsArrayReceiver, SeasonsTableViewCellDelegate, UICollectionViewDelegate, UICollectionViewDataSource, AddTVEventToCollectionDelegate, TVEventsCollectionsStateChangeHandler>

-(void)setMainTvEvent:(TVEvent *)tvEvent;
-(void)setTVEventID:(NSUInteger)tvEventID;
-(void)didSelectRateThisTVEvent;
@end
