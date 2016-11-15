
#import <UIKit/UIKit.h>
#import "ItemsArrayReceiver.h"

@interface SettingsViewController : UIViewController<ItemsArrayReceiver>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *movieNotificationsToggleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *tvShowNotificationsToggleImageView;

@end
