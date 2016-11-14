#import <UIKit/UIKit.h>
#import "CustomCellIdentityProtocol.h"
#import "PersonDetails.h"
#import "ReloadContentHandler.h"

@interface CastMemberInfoTableViewCell : UITableViewCell <CustomCellIdentityProtocol>
@property (weak, nonatomic) IBOutlet UILabel *birthInfoLabel;
@property (weak, nonatomic) IBOutlet UITextView *websiteTextView;
@property (weak, nonatomic) IBOutlet UILabel *biographyLabel;
@property (weak, nonatomic) IBOutlet UILabel *websiteLabel;

@property (weak, nonatomic) IBOutlet UIButton *seeFullBioButton;

-(void)setupWithCastMember:(PersonDetails *)castMemeber delegate:(id<ReloadContentHandler>)delegate;
@end
