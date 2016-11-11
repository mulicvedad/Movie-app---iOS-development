#import <UIKit/UIKit.h>
#import "SideMenuDelegate.h"

@interface SideMenuTableViewController : UITableViewController
-(void)setDelegate:(id<SideMenuDelegate>)delegate;
-(void)setCurrentOption:(SideMenuOption)option;
@end
