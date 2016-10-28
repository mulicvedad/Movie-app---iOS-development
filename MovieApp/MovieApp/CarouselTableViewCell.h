#import <UIKit/UIKit.h>
#import "CustomCellIdentityProtocol.h"

@interface CarouselTableViewCell : UITableViewCell <CustomCellIdentityProtocol>
@property (weak, nonatomic) IBOutlet UICollectionView *carouselCollectionView;

@end
