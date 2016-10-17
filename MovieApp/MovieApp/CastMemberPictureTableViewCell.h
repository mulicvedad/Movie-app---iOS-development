#import <UIKit/UIKit.h>
#import "CustomCellIdentityProtocol.h"

@interface CastMemberPictureTableViewCell : UITableViewCell <CustomCellIdentityProtocol>
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIView *viewForGradient;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

-(void)setupWithName:(NSString *)name imageUrl:(NSURL *)imageUrl;
-(CGFloat)cellHeight;

@end
