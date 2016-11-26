#import <UIKit/UIKit.h>
#import "CastMember.h"
#import "ItemsArrayReceiver.h"
#import "ShowDetailsDelegate.h"
#import "ReloadContentHandler.h"
@interface CastMemberDetailsTableViewController : UITableViewController <ItemsArrayReceiver, ShowDetailsDelegate, UICollectionViewDelegate, UICollectionViewDataSource, ReloadContentHandler>
@property (nonatomic, strong) CastMember *castMember;
@end
