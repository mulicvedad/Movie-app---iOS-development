#import <UIKit/UIKit.h>
#import "SideMenuDelegate.h"
#import "SelectedIndexChangeDelegate.h"
#import "ItemsArrayReceiver.h"
#import "TVEvent.h"
#import "Movie.h"
#import "TVShow.h"
#import "TVEventsCollectionsStateChangeHandler.h"

@interface LikedTVEventsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, SelectedIndexChangeDelegate, ItemsArrayReceiver, TVEventsCollectionsStateChangeHandler>
@property (weak, nonatomic) IBOutlet UITableView *tvEventsTableView;
@property (weak, nonatomic) IBOutlet UITableView *sortByTableView;
-(void)setCurrentOption:(SideMenuOption)option;

@end
