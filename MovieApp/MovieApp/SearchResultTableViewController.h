#import <UIKit/UIKit.h>
#import "ItemsArrayReceiver.h"
#import "ShowDetailsDelegate.h"

@interface SearchResultTableViewController : UITableViewController <ItemsArrayReceiver, ShowDetailsDelegate>

-(void)clearSearchResults;
-(void)performSearchWithQuery:(NSString *)query;
-(void)setDelegateForSegue:(id)delegate;
@end
