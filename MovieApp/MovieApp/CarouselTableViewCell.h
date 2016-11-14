#import <UIKit/UIKit.h>
#import "CustomCellIdentityProtocol.h"

@interface CarouselTableViewCell : UITableViewCell <CustomCellIdentityProtocol>
@property (weak, nonatomic) IBOutlet UICollectionView *carouselCollectionView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@end
