#import "SearchResultTableViewController.h"
#import "SearchResultItemTableViewCell.h"
#import "Movie.h"
#import "TVShow.h"
#import "SearchResultItem.h"
#import "TVEventDetailsTableViewController.h"
#import "DataProviderService.h"
#import "TVEventsViewController.h"

#define  DEFAULT_RESULT_ITEM_HEIGTH 92.0
#define HELVETICA_FONT @"HelveticaNeue"
#define FONT_SIZE_REGULAR 12
#define FONT_SIZE_BIG 18
#define SHOW_DETAILS_SEGUE_IDENTIFIER @"ShowDetailsSegue"
#define SEARCH_RESULT_PAGE_SIZE 20

@interface SearchResultTableViewController (){
    NSMutableArray *_results;
    NSUInteger _numberOfPagesLoaded;
    BOOL _isDownloaderActive;
    BOOL _noMorePages;
    NSString *_query;
    id _delegate;
    id _delegateForSegue;
}

@end

@implementation SearchResultTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configure];
}

-(void)configure{
    self.edgesForExtendedLayout=UIRectEdgeTop;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.backgroundColor=[MovieAppConfiguration getResultsTableViewBackgroungColor];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:[SearchResultItemTableViewCell cellIClassName] bundle:nil] forCellReuseIdentifier:[SearchResultItemTableViewCell cellIdentifier]];
    
    _results=[[NSMutableArray alloc]init];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_results count];
}

-(void)setDelegateForSegue:(id)delegate{
    _delegateForSegue=delegate;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row>((_numberOfPagesLoaded-1)*SEARCH_RESULT_PAGE_SIZE+10) && !_isDownloaderActive){
        _isDownloaderActive=YES;
        [[DataProviderService sharedDataProviderService] performMultiSearchWithQuery:_query page:_numberOfPagesLoaded+1 returnTo:self];
    }
    SearchResultItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[SearchResultItemTableViewCell cellIdentifier] forIndexPath:indexPath];
    [cell registerDelegate:self tableViewRowNumber:indexPath.row];
    [cell setupWithTvEvent:_results[indexPath.row]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return DEFAULT_RESULT_ITEM_HEIGTH;
}

-(void)updateReceiverWithNewData:(NSArray *)customItemsArray info:(NSDictionary *)info{

    for(int i=0;i<[customItemsArray count];i++){
        SearchResultItem *currentItem=(SearchResultItem *)customItemsArray[i];
        if([currentItem.mediaType isEqualToString:@"movie"]){
            [_results addObject:[Movie movieWithSearchResultItem:currentItem]];
        }
        else{
            [_results addObject:[TVShow tvShowWithSearchResultItem:currentItem]];
            
        }
    }
    _numberOfPagesLoaded++;
    _isDownloaderActive=NO;
    [self.tableView reloadData];
}

-(void)showTvEventDetailsForTvEventAtRow:(NSUInteger)row{
    //UISearchController *parentController=(UISearchController *)self.parentViewController;
    //[(UIViewController *)parentController.searchResultsUpdater performSegueWithIdentifier:SHOW_DETAILS_SEGUE_IDENTIFIER sender:_results[row]];
    [_delegateForSegue performSegueWithIdentifier:SHOW_DETAILS_SEGUE_IDENTIFIER sender:_results[row]];
    
}

/*-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:SHOW_DETAILS_SEGUE_IDENTIFIER]){
        TVEventDetailsTableViewController *destinationVC=segue.destinationViewController;
        [destinationVC setMainTvEvent:sender];
    }
}*/

-(void)clearSearchResults{
    [_results removeAllObjects];
    [self.tableView reloadData];
}

-(void)performSearchWithQuery:(NSString *)query{
    [[DataProviderService sharedDataProviderService] cancelAllRequests];
    _query=query;
    _numberOfPagesLoaded=0;
    [_results removeAllObjects];
    [[DataProviderService sharedDataProviderService] performMultiSearchWithQuery:query page:1 returnTo:self];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_delegateForSegue performSegueWithIdentifier:SHOW_DETAILS_SEGUE_IDENTIFIER sender:_results[indexPath.row]];
    //[_delegateForSegue performSegueWithIdentifier:@"test" sender:nil];

}
@end
