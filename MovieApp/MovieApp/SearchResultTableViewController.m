#import "SearchResultTableViewController.h"
#import "SearchResultItemTableViewCell.h"
#import "Movie.h"
#import "TVShow.h"
#import "SearchResultItem.h"
#import "TVEventDetailsTableViewController.h"
#import "DataProviderService.h"
#import "TVEventsViewController.h"

#define SearchResultsPageSize 20

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

static NSString * const EventDetailsSegueIdentifier=@"ShowDetailsSegue";
static CGFloat const ResultItemDefaultHeight=92.0f;

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
    if(indexPath.row>((_numberOfPagesLoaded-1)*SearchResultsPageSize+10) && !_isDownloaderActive){
        _isDownloaderActive=YES;
        [[DataProviderService sharedDataProviderService] performMultiSearchWithQuery:_query page:_numberOfPagesLoaded+1 returnTo:self];
    }
    SearchResultItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[SearchResultItemTableViewCell cellIdentifier] forIndexPath:indexPath];
    [cell registerDelegate:self tableViewRowNumber:indexPath.row];
    [cell setupWithTvEvent:_results[indexPath.row]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ResultItemDefaultHeight;
}

-(void)updateReceiverWithNewData:(NSArray *)customItemsArray info:(NSDictionary *)info{

    for(int i=0;i<[customItemsArray count];i++){
        SearchResultItem *currentItem=(SearchResultItem *)customItemsArray[i];
        if([currentItem.mediaType isEqualToString:MovieMediaType]){
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
    [_delegateForSegue performSegueWithIdentifier:EventDetailsSegueIdentifier sender:_results[row]];
    
}


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
    [_delegateForSegue performSegueWithIdentifier:EventDetailsSegueIdentifier sender:_results[indexPath.row]];

}
@end
