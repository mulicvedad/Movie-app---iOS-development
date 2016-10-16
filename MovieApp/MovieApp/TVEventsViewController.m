#import "TVEventsViewController.h"
#import "TVEventsCollectionViewCell.h"
#import "Movie.h"
#import "TVShow.h"
#import "MovieAppConfiguration.h"
#import "AppDelegate.h"
#import "DataProviderService.h"
#import "TVEventDetailsTableViewController.h"
#import "SortByControlTableViewDelegate.h"
#import "MainSortByTableViewCell.h"
#import "SortByDropDownTableViewCell.h"

#define CRITERION_KEY @"criterion"
#define FILLED_STAR_CODE @"\u2605"
#define UNFILLED_STAR_CODE @"\u2606"
#define TEXT_FIELD_PROPERTY_NAME @"_searchField"
#define SHOW_DETAILS_SEGUE_IDENTIFIER @"ShowDetailsSegue"

#define NUMBER_OF_SECTIONS 2
#define MAIN_SECTION 0
#define DROPDOWN_SECTION 1
#define DEFAULT_CELL_HEIGHT 43.0f

@interface TVEventsViewController (){
    UISearchBar *_searchBar;
    NSArray *_tvEvents;
    NSTimer *_timer;
    NSArray *_criteriaForSorting;
    BOOL _isDropdownActive;
    NSUInteger _selectedIndex;
}

@end

@implementation TVEventsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.isMovieViewController=(self.tabBarController.selectedIndex==1) ? YES:NO;
    [self configureView];
    [self initialDataDownload];
    [self configureSortByControl];
    
    
}

-(void)configureView{
    
    [_tvEventsCollectionView registerNib:[UINib nibWithNibName:[TVEventsCollectionViewCell cellViewClassName] bundle:nil]  forCellWithReuseIdentifier:[TVEventsCollectionViewCell cellIdentifier]];
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    
    self.searchController.edgesForExtendedLayout=UIRectEdgeNone;;
    
    self.navigationItem.titleView = _searchBar;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.resultsContoller=[[SearchResultTableViewController alloc]init];
    self.searchController=[[UISearchController alloc]initWithSearchResultsController:self.resultsContoller];
    
    self.navigationItem.titleView = self.searchController.searchBar;
    self.searchController.searchBar.placeholder=@"Search";
    UITextField *searchTextField = [ self.searchController.searchBar valueForKey:TEXT_FIELD_PROPERTY_NAME];
    searchTextField.backgroundColor = [UIColor darkGrayColor];
    
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate=self;
    self.searchController.dimsBackgroundDuringPresentation = YES;
    self.searchController.hidesNavigationBarDuringPresentation=NO;
    self.searchController.obscuresBackgroundDuringPresentation=YES;
    self.definesPresentationContext=YES;
    
}

-(void)configureSortByControl{
   // SortByControlTableViewDelegate *tableViewDelegate=[[SortByControlTableViewDelegate alloc]init];
    //[tableViewDelegate registerDelegate:self];
    [self.sortByControlTableView registerNib:[UINib nibWithNibName:[MainSortByTableViewCell cellIClassName] bundle:nil] forCellReuseIdentifier:[MainSortByTableViewCell cellIdentifier]];
     [self.sortByControlTableView registerNib:[UINib nibWithNibName:[SortByDropDownTableViewCell cellIClassName] bundle:nil] forCellReuseIdentifier:[SortByDropDownTableViewCell cellIdentifier]];
   _criteriaForSorting=_isMovieViewController ? [Movie getCriteriaForSorting] : [TVShow getCriteriaForSorting];
    self.sortByControlTableView.delegate=self;
    self.sortByControlTableView.dataSource=self;
    /*CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFromTop;//kCATransitionPush;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.fillMode = kCAFillModeForwards;
    transition.duration = 0.6;
    transition.subtype = kCATransitionFromTop;
    
    [self.sortByControlTableView.layer addAnimation:transition forKey:@"UITableViewReloadDataAnimationKey"];*/
    [self.sortByControlTableView reloadData];
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

-(void)initialDataDownload{
    [[DataProviderService sharedDataProviderService] getTvEventsByCriterion:0 returnToHandler:self];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:SHOW_DETAILS_SEGUE_IDENTIFIER sender:_tvEvents[indexPath.row]];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:SHOW_DETAILS_SEGUE_IDENTIFIER] ){
        TVEventDetailsTableViewController *destinationVC=segue.destinationViewController;
        [destinationVC setMainTvEvent:sender];
    }
}

//UISearchResultsUpdating method

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    ((UITableViewController *)searchController.searchResultsController).tableView.hidden=NO;
    
    if(_timer.isValid){
        [_timer invalidate];
        _timer=nil;
    }
    NSString *searchText=searchController.searchBar.text;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                              target:self
                                            selector:@selector(performSearch:)
                                            userInfo:@{@"query":searchText} repeats:NO];
    
    
}

-(void)performSearch:(NSTimer *)timer{
    if([[[timer userInfo] objectForKey:@"query"] length] == 0){
        [(SearchResultTableViewController *)self.searchController.searchResultsController clearSearchResults];
    }
    else{
        [[DataProviderService sharedDataProviderService] performMultiSearchWithQuery:[[timer userInfo] objectForKey:@"query"] returnTo:self.searchController.searchResultsController];
    }
    
}

-(void)selectedIndexChangedTo:(NSUInteger)newIndex{
     [[DataProviderService sharedDataProviderService] getTvEventsByCriterion:(Criterion)newIndex returnToHandler:self];
}


//table view delegate methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return NUMBER_OF_SECTIONS;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==MAIN_SECTION){
        return 1;
    }
    else if(section==DROPDOWN_SECTION && _isDropdownActive){
        return [_criteriaForSorting count];
    }
    else{
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==MAIN_SECTION){
        MainSortByTableViewCell *mainCell=[tableView dequeueReusableCellWithIdentifier:[MainSortByTableViewCell cellIdentifier] forIndexPath:indexPath];
        
        [mainCell setupWithCriterion:_criteriaForSorting[_selectedIndex] isDropDownActive:_isDropdownActive];
        return mainCell;
    }
    else if(indexPath.section==1){
        SortByDropDownTableViewCell *dropDownCell=[tableView dequeueReusableCellWithIdentifier:[SortByDropDownTableViewCell cellIdentifier] forIndexPath:indexPath];
        
        [dropDownCell setupWithCriterion:_criteriaForSorting[indexPath.row] isSelected:(indexPath.row==_selectedIndex)];
        return dropDownCell;
    }
    return nil;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return DEFAULT_CELL_HEIGHT;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _isDropdownActive=!_isDropdownActive;
    if(indexPath.section==DROPDOWN_SECTION){
        _selectedIndex=indexPath.row;
        [self selectedIndexChangedTo:_selectedIndex];
    }
    
    [self.sortByControlTableView reloadData];
    CGRect frame = self.sortByControlTableView.frame;
    frame.size.height = self.sortByControlTableView.contentSize.height;
    self.sortByControlTableView.frame = frame;
    
}



@end
