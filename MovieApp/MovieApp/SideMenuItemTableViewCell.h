#import <UIKit/UIKit.h>

@interface SideMenuItemTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *optionNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *optionImageView;

-(void)setupWithOption:(SideMenuOption)option selected:(BOOL)selected;
@end
