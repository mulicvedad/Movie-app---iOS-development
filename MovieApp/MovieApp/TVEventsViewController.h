#import <UIKit/UIKit.h>
#import "ItemsArrayReceiver.h"

@interface TVEventsViewController : UIViewController <UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, ItemsArrayReceiver>
@property (weak, nonatomic) IBOutlet UICollectionView *tvEventsCollectionView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sortSegmentedControl;
@property (nonatomic) BOOL isMovieViewController;
- (IBAction)sortByChanged:(UISegmentedControl *)sender;

@end
