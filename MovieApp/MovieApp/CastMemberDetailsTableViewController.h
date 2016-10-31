#import <UIKit/UIKit.h>
#import "CastMember.h"
#import "ItemsArrayReceiver.h"
#import "ShowDetailsDelegate.h"

@interface CastMemberDetailsTableViewController : UITableViewController <ItemsArrayReceiver, ShowDetailsDelegate>
@property (nonatomic, strong) CastMember *castMember;
@end
