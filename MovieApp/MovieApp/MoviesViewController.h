#import <UIKit/UIKit.h>
#import "ItemsArrayReceiver.h"

@interface MoviesViewController : UIViewController <UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, ItemsArrayReceiver>
@property (weak, nonatomic) IBOutlet UICollectionView *moviesCollectionView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sortSegmentedControl;

@end
