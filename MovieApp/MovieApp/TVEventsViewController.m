#import "TVEventsViewController.h"
#import "TVEventsCollectionViewCell.h"
#import "Movie.h"
#import "TVShow.h"
#import "MovieAppConfiguration.h"
#import "AppDelegate.h"
#import "DataProviderService.h"
#import "TVEventDetailsTableViewController.h"

#define CRITERION_KEY @"criterion"
#define FILLED_STAR_CODE @"\u2605"
#define UNFILLED_STAR_CODE @"\u2606"
#define TEXT_FIELD_PROPERTY_NAME @"_searchField"
#define MOVIE_SEGUE_IDENTIFIER @"MovieDetailsSegue"
#define TVSHOW_SEGUE_IDENTIFIER @"TVShowDetailsSegue"

@interface TVEventsViewController (){
    UISearchBar *_searchBar;
    NSArray *_tvEvents;
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
    _searchBar=[[UISearchBar alloc]init];
    _searchBar.placeholder=@"Search";
    
    UITextField *searchTextField = [_searchBar valueForKey:TEXT_FIELD_PROPERTY_NAME];
    searchTextField.backgroundColor = [UIColor darkGrayColor];
    
    self.navigationItem.titleView = _searchBar;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _tvEvents ? [_tvEvents count] : 0;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TVEventsCollectionViewCell *cell = [_tvEventsCollectionView dequeueReusableCellWithReuseIdentifier:[TVEventsCollectionViewCell cellIdentifier] forIndexPath:indexPath];
        
    [cell setupWithTvEvent:_tvEvents[indexPath.row]];
    
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

-(void)updateReceiverWithNewData:(NSArray *)customItemsArray info:(NSDictionary *)info{
    _tvEvents=customItemsArray;
    [self.tvEventsCollectionView reloadData];
}

- (IBAction)sortByChanged:(UISegmentedControl *)sender {
        [[DataProviderService sharedDataProviderService] getTvEventsByCriterion:(Criterion)sender.selectedSegmentIndex returnToHandler:self];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:self.isMovieViewController ? MOVIE_SEGUE_IDENTIFIER : TVSHOW_SEGUE_IDENTIFIER sender:_tvEvents[indexPath.row]];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:MOVIE_SEGUE_IDENTIFIER] || [segue.identifier isEqualToString:TVSHOW_SEGUE_IDENTIFIER] ){
        TVEventDetailsTableViewController *destinationVC=segue.destinationViewController;
        [destinationVC setMainTvEvent: _isMovieViewController ? (Movie *)sender : (TVShow *)sender];
    }
}
@end
