#import "TVEventsViewController.h"
#import "TVEventsCollectionViewCell.h"
#import "Movie.h"
#import "TVShow.h"
#import "AppDelegate.h"
#import "DataProviderService.h"
#import "TVEventDetailsTableViewController.h"
#import "SortByControlTableViewDelegate.h"
#import "MainSortByTableViewCell.h"
#import "SortByDropDownTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "SideMenuTableViewController.h"
#import "LikedTVEventsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LoginRequest.h"
#import <KeychainItemWrapper.h>
#import "VirtualDataStorage.h"
#import "DatabaseManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <Realm/Realm.h>
#import "MovieDb.h"
#import "Reachability.h"

#import <CoreSpotlight/CoreSpotlight.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "AlertManager.h"

#define NumberOfSectionsInTable 2
#define TvEventsPageSize 20

@interface TVEventsViewController (){
    UISearchBar *_searchBar;
    NSMutableArray *_tvEvents;
    NSTimer *_timer;
    NSArray *_criteriaForSorting;
    BOOL _isDropdownActive;
    NSUInteger _selectedIndex;
    MainSortByTableViewCell *_mainCell;
    
    NSUInteger _numberOfPagesLoaded;
    BOOL _noMorePages;
    BOOL _pageDownloaderActive;
    BOOL _shouldScrollToTop;
    BOOL _refresh;
    
    UIViewController *_sideMenuViewController;
    UIView *_shadowView;
    
    UIBarButtonItem *_menuButtonItem;
    
    BOOL _isConnected;
    Reachability *_internetReachable;
    
    BOOL _isUserLoggedIn;
    
}

@end
enum{
    SortByTableMainSection,
    SortByTableDropdownSection
};

static NSString * const TextFieldPropertyName=@"_searchField";
static NSString * const EventDetailsSegueIdentifier=@"ShowDetailsSegue";
static NSString * const QueryDictionaryKey=@"query";
static NSString * const BackButtonTitle=@"Back";
static NSString * const SearchBarPlaceholder=@"Search";
static NSString * const RequestFailedMessageTitle=@"Request failed";
static NSString * const RequestFailedMessage=@"Check your connection.";
static NSString * const CancelButtonTitle=@"Cancel" ;
static NSString * const TryAgainButtonTitle=@"Try again" ;
static CGFloat const TimerInterval=0.5f;
static CGFloat const SortByTableDefaultCellHeight=43.0f;
static NSString *LikedTVEventsSegueIdentifier=@"LikedTVEventsSegueIdentifier";
static NSString *LoginSegueIdentifier=@"LoginSegue";
static NSString *SettingsSegueIdentifier=@"SettingsSegue";
static NSString *PlaceholderImageName=@"poster-placeholder-new-medium";
static NSString *SearchableItemIdentifierBase=@"com.atlantbh.internship";
static NSString *SearchableItemMovieDomainIdentifier=@"movie";
static NSString *SearchableItemTVShowDomainIdentifier=@"tv";

@implementation TVEventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _numberOfPagesLoaded=0;
    _tvEvents=[[NSMutableArray alloc]init];
    self.isMovieViewController=(self.tabBarController.selectedIndex==1) ? YES:NO;
    [self configureView];
    [self initialDataDownload];
    [self configureSortByControl];
    [self configureSwipeGestureRecogniser];
    [self configureNotifications];
    [self configureSearchController];
    _menuButtonItem=self.menuButton;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionChanged:) name:kReachabilityChangedNotification object:nil];
    _internetReachable = [Reachability reachabilityForInternetConnection];

    [_internetReachable startNotifier];
    
    _isConnected=[MovieAppConfiguration isConnectedToInternet];
    
    KeychainItemWrapper *myKeyChain=[[KeychainItemWrapper alloc] initWithIdentifier:KeyChainItemWrapperIdentifier accessGroup:nil];
    NSString *username=[myKeyChain objectForKey:(id)kSecAttrAccount];
    if(!username  || [username length]==0){
        _isUserLoggedIn=NO;
    }
    else{
        _isUserLoggedIn=YES;
    }
    
}

-(void)configureView{
    
    [_tvEventsCollectionView registerNib:[UINib nibWithNibName:[TVEventsCollectionViewCell cellViewClassName] bundle:nil]  forCellWithReuseIdentifier:[TVEventsCollectionViewCell cellIdentifier]];
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:BackButtonTitle style:UIBarButtonItemStylePlain target:nil action:nil];
   
    
}

-(void)configureSearchController{
    self.resultsContoller=[[SearchResultTableViewController alloc]init];
    self.searchController=[[UISearchController alloc]initWithSearchResultsController:self.resultsContoller];
    [self.resultsContoller setDelegateForSegue: self];
    
    self.navigationItem.titleView = self.searchController.searchBar;
    
    self.searchController.searchBar.placeholder=SearchBarPlaceholder;
   
    UITextField *searchTextField = [ self.searchController.searchBar valueForKey:TextFieldPropertyName];
    searchTextField.backgroundColor = [UIColor darkGrayColor];
    searchTextField.textColor=[MovieAppConfiguration getPreferredTextColorForSearchBar];
    
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate=self;
    self.searchController.dimsBackgroundDuringPresentation = YES;
    self.searchController.hidesNavigationBarDuringPresentation=NO;
    //self.searchController.obscuresBackgroundDuringPresentation=YES;
    self.definesPresentationContext=YES;
    
    
}
-(void)configureSortByControl{

    [self.sortByControlTableView registerNib:[UINib nibWithNibName:[MainSortByTableViewCell cellIClassName] bundle:nil] forCellReuseIdentifier:[MainSortByTableViewCell cellIdentifier]];
     [self.sortByControlTableView registerNib:[UINib nibWithNibName:[SortByDropDownTableViewCell cellIClassName] bundle:nil] forCellReuseIdentifier:[SortByDropDownTableViewCell cellIdentifier]];
    _mainCell=[self.sortByControlTableView dequeueReusableCellWithIdentifier:[MainSortByTableViewCell cellIdentifier]];
    _mainCell.selectionStyle=UITableViewCellSelectionStyleNone;
   _criteriaForSorting=_isMovieViewController ? [Movie getCriteriaForSorting] : [TVShow getCriteriaForSorting];
    self.sortByControlTableView.delegate=self;
    self.sortByControlTableView.dataSource=self;

    [self.sortByControlTableView reloadData];
}

-(void)configureSwipeGestureRecogniser{
    UISwipeGestureRecognizer *gestureRecogniser=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction)];
    gestureRecogniser.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:gestureRecogniser];
}

-(void)configureNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataStorageReadyNotificationHandler) name:DataStorageReadyNotificationName object:nil];
}

-(void)swipeAction{
    if(_sideMenuViewController){
        [self removeSideMenuViewController:_sideMenuViewController];
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _tvEvents ? [_tvEvents count] : 0;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    TVEventsCollectionViewCell *cell = [_tvEventsCollectionView dequeueReusableCellWithReuseIdentifier:[TVEventsCollectionViewCell cellIdentifier] forIndexPath:indexPath];
    //cell.layer.shouldRasterize = YES;
    //cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    TVEvent *currentTVEvent=_tvEvents[indexPath.row];
    
    if([MovieAppConfiguration isConnectedToInternet]){
        [cell.posterImageView sd_setImageWithURL:[NSURL URLWithString:[BaseImageUrlForWidth185 stringByAppendingString:currentTVEvent.posterPath]] placeholderImage:[UIImage  imageNamed:PlaceholderImageName] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if(image){
                [[DatabaseManager sharedDatabaseManager] addUIImage:image toImageDbWithID:[BaseImageUrlForWidth185 stringByAppendingString:currentTVEvent.posterPath]];
            }
                
                
        }];
    }
    else if(currentTVEvent.posterPath){
        [[DatabaseManager sharedDatabaseManager] addImageWithId:[BaseImageUrlForWidth185 stringByAppendingString:currentTVEvent.posterPath] toImageView:cell.posterImageView];
    }
    else{
        cell.posterImageView.image=[UIImage imageNamed: PlaceholderImageName];
    }
    
    

    [cell setupWithTvEvent:currentTVEvent indexPathRow:indexPath.row callbackDelegate:self];
    if(_isUserLoggedIn){
        cell.addToFavoritesImageView.hidden=NO;
        cell.addToWatchlistImageView.hidden=NO;
    }
    else{
        cell.addToFavoritesImageView.hidden=YES;
        cell.addToWatchlistImageView.hidden=YES;
    }
    if((indexPath.row>(_numberOfPagesLoaded-1)*TvEventsPageSize+10) && !_pageDownloaderActive && !_noMorePages){
        _pageDownloaderActive=YES;
        [[DataProviderService sharedDataProviderService] getTvEventsByCriterion:(Criterion)_selectedIndex page:_numberOfPagesLoaded+1 returnToHandler:self];
    }
    return cell;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellWidth;
    if(UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])){
        cellWidth=collectionView.bounds.size.width/4-8;

    }
    else{
        cellWidth=collectionView.bounds.size.width/2-2;
    }
    
    return CGSizeMake(cellWidth, [TVEventsCollectionViewCell cellHeight]);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return [TVEventsCollectionViewCell cellInsets];
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 2.0;
}


-(void)updateReceiverWithNewData:(NSArray *)customItemsArray info:(NSDictionary *)info{
    if(customItemsArray.count==0 && _tvEvents.count==0 && ![MovieAppConfiguration isConnectedToInternet]){
        [AlertManager displaySimpleAlertWithTitle:@"No data" description:@"Check your internet connection!" displayingController:self shouldPopViewController:NO];
        _noMorePages=YES;
        return;
    }
    if([customItemsArray count]<20){
        _noMorePages=YES;
    }
    
    if(![MovieAppConfiguration isConnectedToInternet]){
        _noMorePages=YES;
    }
    [_tvEvents addObjectsFromArray:customItemsArray];

   /* dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             (unsigned long)NULL), ^(void) {
        [self setupSearchableContent];

    });*/
    
    [self dataStorageReadyNotificationHandler];
    _numberOfPagesLoaded++;
    _pageDownloaderActive=NO;
    
    [self.tvEventsCollectionView reloadData];
    if(_shouldScrollToTop){
        _shouldScrollToTop=NO;
        [self.tvEventsCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
    }
}

-(void)initialDataDownload{
    _pageDownloaderActive=YES;
    [[DataProviderService sharedDataProviderService] getTvEventsByCriterion:0 page:1 returnToHandler:self];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:EventDetailsSegueIdentifier sender:_tvEvents[indexPath.row]];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:EventDetailsSegueIdentifier] ){
        TVEventDetailsTableViewController *destinationVC=segue.destinationViewController;
        [destinationVC setMainTvEvent:sender dalegate:nil];
        /*
         
         second solution to bug
         if(self.searchController.isActive){
         [self.searchController dismissViewControllerAnimated:NO completion:^{
         [self.navigationController pushViewController:destinationVC animated:YES];
         }];
         }
         
         */
        
    }
    else if([segue.identifier isEqualToString:LikedTVEventsSegueIdentifier]){
        LikedTVEventsViewController *destinationVC=segue.destinationViewController;
        [destinationVC setCurrentOption:(SideMenuOption)[(NSNumber *)sender integerValue]];
        
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
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:TimerInterval
                                              target:self
                                            selector:@selector(performSearch:)
                                            userInfo:@{QueryDictionaryKey:searchText} repeats:NO];
    
    
}

-(void)performSearch:(NSTimer *)timer{
    if([[[timer userInfo] objectForKey:QueryDictionaryKey] length] == 0){
        [(SearchResultTableViewController *)self.searchController.searchResultsController clearSearchResults];
    }
    else{
        [(SearchResultTableViewController *)self.searchController.searchResultsController performSearchWithQuery:[[timer userInfo] objectForKey:@"query"]];
    }
    
}

-(void)selectedIndexChangedTo:(NSUInteger)newIndex{
    _numberOfPagesLoaded=0;
    if(_tvEvents.count>0){
        _shouldScrollToTop=YES;
    }
    else{
        _shouldScrollToTop=NO;
    }
    [_tvEvents removeAllObjects];
    [[DataProviderService sharedDataProviderService] cancelAllRequests];
    _pageDownloaderActive=YES;
    [[DataProviderService sharedDataProviderService] getTvEventsByCriterion:(Criterion)newIndex page:1 returnToHandler:self];
}


//sort by table view delegate methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return NumberOfSectionsInTable;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==SortByTableMainSection){
        return 1;
    }
    else if(section==SortByTableDropdownSection && _isDropdownActive){
        return [_criteriaForSorting count];
    }
    else{
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==SortByTableMainSection){
        [_mainCell setupWithCriterion:_criteriaForSorting[_selectedIndex] isDropDownActive:_isDropdownActive isFilterBy:NO];
        return _mainCell;
    }
    else if(indexPath.section==1){
        SortByDropDownTableViewCell *dropDownCell=[tableView dequeueReusableCellWithIdentifier:[SortByDropDownTableViewCell cellIdentifier] forIndexPath:indexPath];
    
        [dropDownCell setupWithCriterion:_criteriaForSorting[indexPath.row] isSelected:(indexPath.row==_selectedIndex)];
        return dropDownCell;
    }
    return nil;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SortByTableDefaultCellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _isDropdownActive=!_isDropdownActive;
    if(indexPath.section==SortByTableDropdownSection){
        _selectedIndex=indexPath.row;
        [self selectedIndexChangedTo:_selectedIndex];
    }
    [self.sortByControlTableView reloadData];
    CGRect frame = self.sortByControlTableView.frame;
    frame.size.height = self.sortByControlTableView.contentSize.height;
    self.sortByControlTableView.frame = frame;
   
    
}


//handling orientation changes
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
   
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        [self.tvEventsCollectionView reloadData];
        
    }];
}


-(void)handleError:(NSError *)error{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:RequestFailedMessageTitle
                                                                   message:RequestFailedMessage
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:CancelButtonTitle style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    UIAlertAction* reloadAction = [UIAlertAction actionWithTitle:TryAgainButtonTitle style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action)
                                   {
                                       _numberOfPagesLoaded=0;
                                       _pageDownloaderActive=YES;
                                       [_tvEvents removeAllObjects];
                                       [self initialDataDownload];
                                       
                                   }];
    
    [alert addAction:defaultAction];
    [alert addAction:reloadAction];
    //[self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)menuButtonPressed:(id)sender {
    if(!_sideMenuViewController){
        SideMenuTableViewController *newVC=[[SideMenuTableViewController alloc]init];
        [newVC setDelegate:self];
        [newVC setCurrentOption:SideMenuOptionNone];
        [self presentSideMenuViewController:newVC];
    }
    else{
        [self removeSideMenuViewController:nil];
    }
    
}

-(void)presentSideMenuViewController:(UIViewController *)sideMenuViewController{
    _sideMenuViewController=sideMenuViewController;
    [self addChildViewController:sideMenuViewController];
    [self.view addSubview:sideMenuViewController.view];
    sideMenuViewController.view.backgroundColor=[UIColor blackColor];
    sideMenuViewController.view.frame=CGRectMake(0, 0, 0, self.view.frame.size.height);
    [sideMenuViewController didMoveToParentViewController:self];
    [UIView animateWithDuration:0.6 delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         sideMenuViewController.view.frame=CGRectMake(0, 0, self.view.frame.size.width/2, self.view.frame.size.height);
                         
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [self addShadow];

                             
                         }
                     }];

}

-(void)removeSideMenuViewController:(UIViewController *)sideMenuViewControllerOrNil{
    [self removeShadow];
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _sideMenuViewController.view.frame=CGRectMake(-_sideMenuViewController.view.frame.size.width, 0, _sideMenuViewController.view.frame.size.width, _sideMenuViewController.view.frame.size.height);
                         [_sideMenuViewController removeFromParentViewController];

                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [_sideMenuViewController.view removeFromSuperview];
                             _sideMenuViewController=nil;
                             
                         }
                     }];
    
}

-(void)addShadow{
    if(!_shadowView){
        _shadowView=[[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _shadowView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }
    
    [self.view addSubview:_shadowView];
}

-(void)removeShadow{
    [_shadowView removeFromSuperview];
}

-(void)doActionForOption:(SideMenuOption)option{
    [self removeShadow];
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _sideMenuViewController.view.frame=CGRectMake(-_sideMenuViewController.view.frame.size.width, 0, _sideMenuViewController.view.frame.size.width, _sideMenuViewController.view.frame.size.height);
                         [_sideMenuViewController removeFromParentViewController];
                         
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [_sideMenuViewController.view removeFromSuperview];
                             _sideMenuViewController=nil;
                             switch (option) {
                                 case SideMenuOptionLogin:
                                     [self performSegueWithIdentifier:LoginSegueIdentifier sender:nil];
                                     break;
                                 case SideMenuOptionSettings:
                                     [self performSegueWithIdentifier:SettingsSegueIdentifier sender:nil];
                                     break;
                                 case SideMenuOptionLogout:
                                     [self handleLogoutRequest];
                                     break;
                                 case SideMenuOptionNone:
                                     //error
                                     break;
                                 default:
                                     [self performSegueWithIdentifier:LikedTVEventsSegueIdentifier sender:[NSNumber numberWithInt:option]];
                                     break;
                             }
                             
                         }
                     }];
}

-(void)handleLogoutRequest{
    
    NSMutableAttributedString *alertTitle = [[NSMutableAttributedString alloc] initWithString:@"Logout" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    NSMutableAttributedString *alertMessage = [[NSMutableAttributedString alloc] initWithString:@"\nAre you sure you want to log out?" attributes:@{NSForegroundColorAttributeName:[MovieAppConfiguration getPrefferedLightGreyColor],                                                   NSFontAttributeName:[MovieAppConfiguration getPreferredFontWithSize:12 isBold:NO ]}];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:EmptyString
                                                                   message:EmptyString
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert setValue:alertTitle forKey:@"attributedTitle"];
    [alert setValue:alertMessage forKey:@"attributedMessage"];
    
    UIAlertAction* noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {
                                                          
                                                      }];
    UIAlertAction* yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              KeychainItemWrapper *myKeyChain=[[KeychainItemWrapper alloc] initWithIdentifier:KeyChainItemWrapperIdentifier accessGroup:nil];
                                                             // [myKeyChain setObject:EmptyString forKey:(id)kSecAttrAccount];
                                                             // [myKeyChain setObject:EmptyString forKey:(id)kSecValueData];
                                                              [myKeyChain resetKeychainItem];
                                                              [[DatabaseManager sharedDatabaseManager] removeUserRelatedInfo];
                                                              [[NSUserDefaults standardUserDefaults] setBool:NO forKey:TVShowsNotificationsEnabledNSUserDefaultsKey];
                                                              [[NSUserDefaults standardUserDefaults] setBool:NO forKey:MoviesNotificationsEnabledNSUserDefaultsKey];
                                                              //[self.tvEventsCollectionView reloadData];
                                                              _isUserLoggedIn=NO;
                                                              [self connectionChanged:nil];
                                                          }];
    
    
    [alert addAction:noAction];
    [alert addAction:yesAction];
    alert.view.tintColor=[MovieAppConfiguration getPrefferedYellowColorWithOpacity:0.5f];
    UIView *subView = alert.view.subviews.firstObject;
    UIView *alertContentView = subView.subviews.firstObject;
    for (UIView *subSubView in alertContentView.subviews) {
        subSubView.backgroundColor = [MovieAppConfiguration getPreferredDarkGreyColor];
    }
    [self presentViewController:alert animated:YES completion:nil];

   
}

-(void)addTVEventToCollection:(SideMenuOption)typeOfCollection indexPathRow:(NSUInteger)indexPathRow{
    MediaType mediaType= [_tvEvents[indexPathRow] isKindOfClass:[Movie class]] ? MovieType : TVShowType;
    TVEvent *currentTVEvent=_tvEvents[indexPathRow];
    if(typeOfCollection==SideMenuOptionFavorites){
        [[DataProviderService sharedDataProviderService] favoriteTVEventWithID:currentTVEvent.id mediaType:mediaType remove:currentTVEvent.isInFavorites responseHandler:self];
    }
    else{

        [[DataProviderService sharedDataProviderService] addToWatchlistTVEventWithID:currentTVEvent.id  mediaType:mediaType remove:currentTVEvent.isInWatchlist responseHandler:self];

    }
}

-(void)addedTVEventWithID:(NSUInteger)tvEventID toCollectionOfType:(SideMenuOption)typeOfCollection{
    for(int i=0;i<[_tvEvents count];i++){
        TVEvent *currentTVEvent=_tvEvents[i];
        if(currentTVEvent.id==tvEventID){
            switch (typeOfCollection) {
                case SideMenuOptionFavorites:
                    currentTVEvent.isInFavorites=YES;
                    
                    break;
                case SideMenuOptionWatchlist:
                    currentTVEvent.isInWatchlist=YES;
                    
                    break;
                default:
                    break;
            }
            [self.tvEventsCollectionView reloadData];
            break;
        }
    }
}

-(void)removedTVEventWithID:(NSUInteger)tvEventID fromCollectionOfType:(SideMenuOption)typeOfCollection{
        for(int i=0;i<[_tvEvents count];i++){
            TVEvent *currentTVEvent=_tvEvents[i];
            if(currentTVEvent.id==tvEventID){
                switch (typeOfCollection) {
                    case SideMenuOptionFavorites:
                        currentTVEvent.isInFavorites=NO;
                  
                        break;
                    case SideMenuOptionWatchlist:
                        currentTVEvent.isInWatchlist=NO;
                      
                        break;
                    default:
                        break;
                }
                
                [self.tvEventsCollectionView reloadData];
                break;
            }
        }
}

-(void)dataStorageReadyNotificationHandler{
    DatabaseManager *sharedDatabaseManager=[DatabaseManager sharedDatabaseManager];
    
    for(int i=0;i<[_tvEvents count];i++){
        if([sharedDatabaseManager containsTVEventInFavorites:_tvEvents[i]]){
            ((TVEvent *)_tvEvents[i]).isInFavorites=YES;
        }
        else{
            ((TVEvent *)_tvEvents[i]).isInFavorites=NO;

        }
        if([sharedDatabaseManager containsTVEventInWatchlist:_tvEvents[i]]){
            ((TVEvent *)_tvEvents[i]).isInWatchlist=YES;
        }
        else{
            ((TVEvent *)_tvEvents[i]).isInWatchlist=NO;
        }
        
    }
    [self.tvEventsCollectionView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    for(int i=0;i<[_tvEvents count];i++){
        TVEvent * currentTVEvent=_tvEvents[i];
        if([[DatabaseManager sharedDatabaseManager] containsTVEventInFavorites:currentTVEvent]){
            currentTVEvent.isInFavorites=YES;
        }
        else{
            currentTVEvent.isInFavorites=NO;
            
        }
        if([[DatabaseManager sharedDatabaseManager] containsTVEventInWatchlist:currentTVEvent]){
            currentTVEvent.isInWatchlist=YES;
        }
        else{
            currentTVEvent.isInWatchlist=NO;
            
        }
    }
    [self.tvEventsCollectionView reloadData];
    self.navigationItem.titleView=nil;
    self.navigationItem.titleView = self.searchController.searchBar;
    
    self.searchController.searchBar.placeholder=SearchBarPlaceholder;
    
    UITextField *searchTextField = [ self.searchController.searchBar valueForKey:TextFieldPropertyName];
    searchTextField.backgroundColor = [UIColor darkGrayColor];
    searchTextField.textColor=[MovieAppConfiguration getPreferredTextColorForSearchBar];
    
    KeychainItemWrapper *myKeyChain=[[KeychainItemWrapper alloc] initWithIdentifier:KeyChainItemWrapperIdentifier accessGroup:nil];
    NSString *username=[myKeyChain objectForKey:(id)kSecAttrAccount];
    if(!username  || [username length]==0){
        _isUserLoggedIn=NO;
    }
    else{
        _isUserLoggedIn=YES;
    }
  
   
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(_tvEvents.count==0 && _noMorePages){
         [AlertManager displaySimpleAlertWithTitle:@"No data" description:@"Check your internet connection!" displayingController:self shouldPopViewController:NO];
    }
   
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationItem.titleView=[[UISearchBar alloc] init];

}

-(void)didDismissSearchController:(UISearchController *)searchController{
    //this is the forced solution to the bug
    if(_isMovieViewController){
        [self.tabBarController setSelectedIndex:2];
        [self.tabBarController setSelectedIndex:1];
    }
    else{
        [self.tabBarController setSelectedIndex:1];
        [self.tabBarController setSelectedIndex:2];
    }
    [self.navigationItem setLeftBarButtonItem:_menuButtonItem];

    
    
}
-(void)willPresentSearchController:(UISearchController *)searchController{
    [self.navigationItem setLeftBarButtonItem:nil];
}

-(void)setupSearchableContent{
   
    NSMutableArray *searchableItems=[[NSMutableArray alloc] init];
    
    int rowNum=0;
    for(TVEvent *tvEvent in _tvEvents){
        CSSearchableItemAttributeSet *attributeSet=[[CSSearchableItemAttributeSet alloc] initWithItemContentType:(NSString *)kUTTypeText];
        
        if(tvEvent.title){
            attributeSet.title=[NSString stringWithFormat:@"%@ (%@)", tvEvent.title, [tvEvent getReleaseYear]];
        }
        else{
            attributeSet.title=@"Title not found";
        }
        
        
        NSString *mediaType;
        if([tvEvent isKindOfClass:[Movie class]]){
            mediaType=@"Movie";
        }
        else{
            mediaType=@"TV Series";
            
        }
        NSString *genres=[tvEvent getFormattedGenresRepresentation];
        
        attributeSet.contentDescription=[NSString stringWithFormat:@"%@ (%@)",mediaType, genres];
        
        attributeSet.thumbnailData= UIImageJPEGRepresentation([UIImage imageNamed:@"poster-placeholder-new-medium]"], 0.5);
        
        if(tvEvent.posterPath){
            UIImage *posterImage=[[DatabaseManager sharedDatabaseManager] getUIImageFromImageDbWithID:[BaseImageUrlForWidth185 stringByAppendingString:tvEvent.posterPath]];
            if(posterImage){
                NSData *imageData=UIImageJPEGRepresentation(posterImage, 0.5);
                attributeSet.thumbnailData= imageData;
            }
        }
        
        NSMutableArray *keywords=[[NSMutableArray alloc] init];
       
        for(int i=0;i<tvEvent.genreIDs.count;i++){
            [keywords addObject:[tvEvent getGenreNameForId:[(NSNumber *)tvEvent.genreIDs[i] integerValue]]];
        }
        [keywords addObject:tvEvent.title];
        
        attributeSet.keywords=keywords;
        NSString *identifier;
        NSString *domainIdentifier;
        if([tvEvent isKindOfClass:[Movie class]]){
            domainIdentifier=SearchableItemMovieDomainIdentifier;
            identifier=[NSString stringWithFormat:@"%@.%@%d",SearchableItemIdentifierBase, SearchableItemMovieDomainIdentifier,(int)tvEvent.id];

        }
        else{
            domainIdentifier=SearchableItemTVShowDomainIdentifier;
            identifier=[NSString stringWithFormat:@"%@.%@%d",SearchableItemIdentifierBase, SearchableItemTVShowDomainIdentifier,(int)tvEvent.id];
        }
        
        
        CSSearchableItem *item=[[CSSearchableItem alloc] initWithUniqueIdentifier:identifier domainIdentifier:domainIdentifier attributeSet:attributeSet];
        
        [searchableItems addObject:item];
        
        rowNum++;
        
    }
    
    [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:searchableItems completionHandler:^(NSError * _Nullable error) {
        if(error){
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}


-(void)restoreUserActivityState:(NSUserActivity *)activity{
    
    if([activity.activityType isEqualToString:CSSearchableItemActionType]){
        NSDictionary *userInfo=activity.userInfo;
        
        if(userInfo){
            NSString *identifier = [userInfo objectForKey:CSSearchableItemActivityIdentifier];

            NSString *numberString;
            
            NSScanner *scanner = [NSScanner scannerWithString:identifier];
            NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
            
            [scanner scanUpToCharactersFromSet:numbers intoString:NULL];

            [scanner scanCharactersFromSet:numbers intoString:&numberString];
            
            NSInteger number = [numberString integerValue];
            
            TVEvent *tvEvent;
            if ([identifier rangeOfString:SearchableItemMovieDomainIdentifier].location != NSNotFound){
                Movie *movie=[[Movie alloc] init];
                movie.id=number;
                tvEvent=movie;
            }
            else if([identifier rangeOfString:SearchableItemTVShowDomainIdentifier].location != NSNotFound){
                TVShow *tvShow=[[TVShow alloc] init];
                tvShow.id=number;
                tvEvent=tvShow;
            }
            TVEventDetailsTableViewController *detailsViewController=[[TVEventDetailsTableViewController alloc] init];
            [detailsViewController setMainTvEvent:tvEvent dalegate:nil];

            [self performSegueWithIdentifier:EventDetailsSegueIdentifier sender:tvEvent];
        }
    }
}

-(void)connectionChanged:(NSNotification *)notification{
    
        _numberOfPagesLoaded=0;
        if(_tvEvents.count>0){
            [_tvEvents removeAllObjects];
            _noMorePages=NO;
            _numberOfPagesLoaded=0;
            [self.tvEventsCollectionView reloadData];
        }
        else{
            _shouldScrollToTop=NO;
        }
        
        [[DataProviderService sharedDataProviderService] cancelAllRequests];
        _pageDownloaderActive=YES;
        [[DataProviderService sharedDataProviderService] getTvEventsByCriterion:(Criterion)_selectedIndex page:1 returnToHandler:self];
    
   
    
}

-(BOOL)connectionChanged{
    if(_isConnected != [MovieAppConfiguration isConnectedToInternet]){
        _isConnected=[MovieAppConfiguration isConnectedToInternet];
        
        return YES;
    }
    return NO;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
@end
