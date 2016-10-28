#import <UIKit/UIKit.h>
#import "CustomCellIdentityProtocol.h"
#import "CastMember.h"

@interface CastMemberPictureTableViewCell : UITableViewCell <CustomCellIdentityProtocol>
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIView *viewForGradient;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

-(void)setupWithName:(NSString *)name imageUrl:(NSURL *)imageUrl;
-(void)setupWithCastMember:(CastMember *)castMember;
-(CGFloat)cellHeight;

@end
