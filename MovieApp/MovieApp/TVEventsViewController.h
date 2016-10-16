#import <UIKit/UIKit.h>
#import "ItemsArrayReceiver.h"
#import "SearchResultTableViewController.h"
#import "SelectedIndexChangeDelegate.h"

@interface TVEventsViewController : UIViewController <UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, ItemsArrayReceiver, UISearchResultsUpdating, UISearchControllerDelegate, SelectedIndexChangeDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *tvEventsCollectionView;
@property (weak, nonatomic) IBOutlet UITableView *sortByControlTableView;
@property (nonatomic) BOOL isMovieViewController;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) SearchResultTableViewController *resultsContoller;

@end
