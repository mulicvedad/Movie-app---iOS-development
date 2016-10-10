#import <UIKit/UIKit.h>
#import "FeedDownloader.h"
#import "ItemsArrayReceiver.h"


@interface NewsFeedTableViewController : UITableViewController <ItemsArrayReceiver>
-(void)startDownload;
-(void)configureView;
@end
