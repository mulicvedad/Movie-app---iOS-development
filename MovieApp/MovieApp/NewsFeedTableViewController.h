#import <UIKit/UIKit.h>
#import "FeedDownloader.h"
#import "ItemsArrayReceiver.h"
#import "SideMenuDelegate.h"

@interface NewsFeedTableViewController : UITableViewController <ItemsArrayReceiver,SideMenuDelegate>
-(void)startDownload;
-(void)configureView;
@end
