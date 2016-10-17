#import <UIKit/UIKit.h>
#import "CustomCellIdentityProtocol.h"
#import "CastMember.h"

@interface CastMemberInfoTableViewCell : UITableViewCell <CustomCellIdentityProtocol>
@property (weak, nonatomic) IBOutlet UILabel *birthInfoLabel;
@property (weak, nonatomic) IBOutlet UITextView *websiteTextView;
@property (weak, nonatomic) IBOutlet UILabel *biographyLabel;
@property (weak, nonatomic) IBOutlet UITextView *biographyLinkTextView;


-(void)setupWithCastMember:(CastMember *)castMemeber;
@end
