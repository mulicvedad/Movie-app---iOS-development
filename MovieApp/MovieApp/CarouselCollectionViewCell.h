#import <UIKit/UIKit.h>
#import "CustomCellIdentityProtocol.h"
#import "CastMember.h"
#import "Movie.h"
@interface CarouselCollectionViewCell : UICollectionViewCell <CustomCellIdentityProtocol>

@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rolesLabel;


-(void)setupWithCastMember:(CastMember *)castMember;
-(void)setupWithTVEvent:(TVEventCredit *)tvEvent castMember:(CastMember *)castMember;
@end
