#import "TVEventsViewController.h"
#import "TVEventsCollectionViewCell.h"
#import "Movie.h"
#import "MovieAppConfiguration.h"
#import "AppDelegate.h"
#import "DataProviderService.h"
#import "MovieDetailsViewController.h"

#define CRITERION_KEY @"criterion"
#define FILLED_STAR_CODE @"\u2605"
#define UNFILLED_STAR_CODE @"\u2606"
#define TEXT_FIELD_PROPERTY_NAME @"_searchField"
#define DETAILS_SEGUE_IDENTIFIER @"MovieDetailsSegue"

@interface TVEventsViewController (){
    UISearchBar *searchBar;
    NSArray *tvEvents;
}

@end

@implementation TVEventsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.isMovieViewController=(self.tabBarController.selectedIndex==1) ? YES:NO;
    [self configureView];

    [self.sortSegmentedControl setSelectedSegmentIndex:2];
    [self.sortSegmentedControl setSelectedSegmentIndex:0];
    [self.sortSegmentedControl sendActionsForControlEvents:UIControlEventValueChanged];
}

-(void)configureView{
    
    [_tvEventsCollectionView registerNib:[UINib nibWithNibName:[TVEventsCollectionViewCell cellViewClassName] bundle:nil]  forCellWithReuseIdentifier:[TVEventsCollectionViewCell cellIdentifier]];
    searchBar=[[UISearchBar alloc]init];
    searchBar.placeholder=@"Search";
    
    UITextField *searchTextField = [searchBar valueForKey:TEXT_FIELD_PROPERTY_NAME];
    searchTextField.backgroundColor = [UIColor darkGrayColor];
    
    self.navigationItem.titleView = searchBar;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return tvEvents ? [tvEvents count] : 0;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TVEventsCollectionViewCell *cell = [_tvEventsCollectionView dequeueReusableCellWithReuseIdentifier:[TVEventsCollectionViewCell cellIdentifier] forIndexPath:indexPath];
        
    [cell setupWithTvEvent:tvEvents[indexPath.row]];
    
    return cell;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellWidth=collectionView.bounds.size.width/2-2;
 
    return CGSizeMake(cellWidth, [TVEventsCollectionViewCell cellHeight]);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return [TVEventsCollectionViewCell cellInsets];
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 2.0;
}

-(void)updateReceiverWithNewData:(NSMutableArray *)customItemsArray info:(NSDictionary *)info{
    tvEvents=customItemsArray;
    [self.tvEventsCollectionView reloadData];
}

- (IBAction)sortByChanged:(UISegmentedControl *)sender {
        [[DataProviderService sharedDataProviderService] getTvEventsByCriterion:(Criterion)sender.selectedSegmentIndex returnToHandler:self];
}

@end
