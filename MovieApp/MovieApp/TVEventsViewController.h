#import <UIKit/UIKit.h>
#import "ItemsArrayReceiver.h"
#import "SearchResultTableViewController.h"

@interface TVEventsViewController : UIViewController <UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, ItemsArrayReceiver, UISearchResultsUpdating, UISearchControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *tvEventsCollectionView;
@property (nonatomic) BOOL isMovieViewController;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) SearchResultTableViewController *resultsContoller;

@end
