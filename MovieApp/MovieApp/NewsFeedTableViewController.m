#import "NewsFeedTableViewController.h"
#import "FeedTableViewCell.h"
#import "NewFeedsItem.h"
#import "FeedDownloader.h"
#import "DataProviderService.h"

@interface NewsFeedTableViewController (){
    NSMutableArray *_news;
    UISearchBar *_searchBar;
    FeedDownloader *_downloader;
}

@end

static NSString * const NewsFeedNavigationItemTitle=@"News Feed";
static NSString * const RequestFailedMessageTitle=@"Request failed";
static NSString * const RequestFailedMessage=@"Check your connection.";
static NSString * const CancelButtonTitle=@"Cancel" ;
static NSString * const TryAgainButtonTitle=@"Try again" ;
static NSString * const OKButtonTitle=@"OK" ;
static NSString * const ErrorMessageTitle=@"Error" ;

@implementation NewsFeedTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
    _downloader = [[FeedDownloader alloc]init];
    [self startDownload];
    [self.tabBarController setSelectedIndex:1];
}
-(void)updateReceiverWithNewData:(NSArray *)customItemsArray info:(NSDictionary *)info{
    _news=[NSMutableArray arrayWithArray: customItemsArray];
    
    if(![_news count] || !_news)
    {
        if(!_news)
        {
            _news = [[NSMutableArray alloc] init];
        }
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:RequestFailedMessageTitle
                                                                       message:RequestFailedMessage
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:CancelButtonTitle  style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        UIAlertAction* reloadAction = [UIAlertAction actionWithTitle:TryAgainButtonTitle style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action)
                                       {
                                           [self startDownload];
                                           
                                       }];
        
        [alert addAction:defaultAction];
        [alert addAction:reloadAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    
    [self.tableView reloadData];
    
}



-(void)configureView{
    [self.tableView registerNib:[UINib nibWithNibName:[FeedTableViewCell cellViewClassName] bundle:nil] forCellReuseIdentifier:[FeedTableViewCell cellIdentifier]];
    
    self.navigationItem.title=NewsFeedNavigationItemTitle;
    
    self.tableView.rowHeight=UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight=200.0;
}

-(void)startDownload{
    
    @try {
        [_downloader downloadNewsFromFeed:[MovieAppConfiguration getFeedsSourceUrlPath] andReturnTo:self];
        
    } @catch (NSException *exception) {
        [_news removeAllObjects];
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:ErrorMessageTitle
                                                                       message:[exception description]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:OKButtonTitle style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_news count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedTableViewCell *feedCell = [tableView dequeueReusableCellWithIdentifier:[FeedTableViewCell cellIdentifier] forIndexPath:indexPath];
    
    [feedCell setupWithNewsFeedItem:_news[indexPath.row]];
    
    
    return feedCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

@end
