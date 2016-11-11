#import "LikedTVEventsViewController.h"
#import "SortByTableViewDelegate.h"
#import "DataProviderService.h"
#import "SearchResultItemTableViewCell.h"
#import "TVEventDetailsTableViewController.h"

#define TvEventsPageSize 20

@interface LikedTVEventsViewController (){
    SortByTableViewDelegate *_sortByTableViewDelegate;
    NSUInteger _currentSelectedIndex;
    SideMenuOption _currentOption;
    NSMutableArray *_tvEvents;
    
    //for paging implementation
    NSUInteger _numberOfPagesLoaded;
    BOOL _noMorePages;
    BOOL _pageDownloaderActive;
    BOOL _shouldScrollToTop;
    BOOL _refresh;
}

@end

static NSString *RequestFailedMessageTitle=@"Request failed";
static NSString *RequestFailedMessage=@"Check your connection.";
static NSString *CancelButtonTitle=@"Cancel" ;
static NSString *EventDetailsSegueIdentifier=@"EventDetailsSegue";
static NSString *TryAgainButtonTitle=@"Try again";
static CGFloat defaultTableViewCellHeight=92.0f;

@implementation LikedTVEventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configure];
    [self fetchTVEventsForPageNumber:_numberOfPagesLoaded+1];
}

-(void)configure{
    [self setupSortByTableView];
    _tvEvents=[[NSMutableArray alloc]init];
    [self.tvEventsTableView registerNib:[UINib nibWithNibName: NSStringFromClass([SearchResultItemTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SearchResultItemTableViewCell class]) ];
    self.navigationItem.title=[MovieAppConfiguration getStringRepresentationOfSideMenuOption:_currentOption];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
   }
-(void)setupSortByTableView{
    _sortByTableViewDelegate=[[SortByTableViewDelegate alloc] init];
    _sortByTableViewDelegate.sortByControlTableView=self.sortByTableView;
    [_sortByTableViewDelegate configureWithCriteriaForSorting:[MovieAppConfiguration getCriteriaForLikedTVEventsSorting] selectionHandlerDelegate:self];
    self.sortByTableView.delegate=_sortByTableViewDelegate;
    self.sortByTableView.dataSource=_sortByTableViewDelegate;
    
    [self.sortByTableView reloadData];

}

-(void)fetchTVEventsForPageNumber:(NSUInteger)pageNumber{
    _pageDownloaderActive=YES;
    switch (_currentOption) {
        case SideMenuOptionFavorites:
            [[DataProviderService sharedDataProviderService] getFavoriteTVEventsOfType:(MediaType)_currentSelectedIndex pageNumber:pageNumber returnTo:self];
            break;
        case SideMenuOptionWatchlist:
            [[DataProviderService sharedDataProviderService] getWatchlistOfType:(MediaType)_currentSelectedIndex pageNumber:pageNumber  returnTo:self];
            break;
        case SideMenuOptionRatings:
            [[DataProviderService sharedDataProviderService] getRatedTVEventsOfType:(MediaType)_currentSelectedIndex pageNumber:pageNumber returnTo:self];
            break;
        default:
            //internal error
            _pageDownloaderActive=NO;
            break;
    }
    
}
-(void)setCurrentOption:(SideMenuOption)option{
    _currentOption=option;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_tvEvents count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchResultItemTableViewCell *cell=[self.tvEventsTableView dequeueReusableCellWithIdentifier:NSStringFromClass([SearchResultItemTableViewCell class])];
    [cell configureForLikedTVEvents];
    [cell setupWithTvEvent:_tvEvents[indexPath.row]];
    if((indexPath.row>(_numberOfPagesLoaded-1)*TvEventsPageSize+10) && !_pageDownloaderActive && !_noMorePages){
        _pageDownloaderActive=YES;
        [self fetchTVEventsForPageNumber:_numberOfPagesLoaded+1];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return defaultTableViewCellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:EventDetailsSegueIdentifier sender:_tvEvents[indexPath.row]];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:EventDetailsSegueIdentifier]){
        TVEventDetailsTableViewController *destinationVC=segue.destinationViewController;
        [destinationVC setMainTvEvent:(TVEvent *)sender];
    }
}

-(void)selectedIndexChangedTo:(NSUInteger)newIndex{
    _currentSelectedIndex=newIndex;
    _numberOfPagesLoaded=0;
    _shouldScrollToTop=YES;
    [_tvEvents removeAllObjects];
    [[DataProviderService sharedDataProviderService] cancelAllRequests];
    _pageDownloaderActive=YES;
    [self fetchTVEventsForPageNumber:_numberOfPagesLoaded+1];
}

-(void)updateReceiverWithNewData:(NSArray *)customItemsArray info:(NSDictionary *)info{
    if(!customItemsArray){
        [self handleError:[info objectForKey:ErrorDictionaryKey]];
        _noMorePages=YES;
        return;
    }
    if([customItemsArray count]<20){
        _noMorePages=YES;
    }
    [_tvEvents addObjectsFromArray:customItemsArray];
    _numberOfPagesLoaded++;
    _pageDownloaderActive=NO;
    [self.tvEventsTableView reloadData];
    if(_shouldScrollToTop){
        _shouldScrollToTop=NO;
        [self.tvEventsTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
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
                                       [self fetchTVEventsForPageNumber:_numberOfPagesLoaded+1];
                                       
                                   }];
    
    [alert addAction:defaultAction];
    [alert addAction:reloadAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
