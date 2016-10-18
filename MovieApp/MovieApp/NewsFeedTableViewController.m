#import "NewsFeedTableViewController.h"
#import "FeedTableViewCell.h"
#import "NewFeedsItem.h"
#import "FeedDownloader.h"

#define TEXT_FIELD_PROPERTY_NAME @"_searchField"

@interface NewsFeedTableViewController (){
    NSMutableArray *_news;
    UISearchBar *_searchBar;
    FeedDownloader *_downloader;
}

@end

@implementation NewsFeedTableViewController

-(void)updateReceiverWithNewData:(NSArray *)customItemsArray info:(NSDictionary *)info{
    _news=[NSMutableArray arrayWithArray: customItemsArray];
    
    if(![_news count])
    {
        if(!_news)
        {
            _news = [[NSMutableArray alloc] init];
        }
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"No results"
                                                                       message:@"There arent any news."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        UIAlertAction* reloadAction = [UIAlertAction actionWithTitle:@"Try again" style:UIAlertActionStyleDefault
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
    _downloader = [[FeedDownloader alloc]init];
    [self startDownload];
}

-(void)configureView{
    [self.tableView registerNib:[UINib nibWithNibName:[FeedTableViewCell cellViewClassName] bundle:nil] forCellReuseIdentifier:[FeedTableViewCell cellIdentifier]];
    
    self.navigationItem.title=@"News Feed";
    
    self.tableView.rowHeight=UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight=200.0;
}

-(void)startDownload{
    
    @try {
        [_downloader downloadNewsFromFeed:[MovieAppConfiguration getFeedsSourceUrlPath] andReturnTo:self];
        
    } @catch (NSException *exception) {
        [_news removeAllObjects];
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:[exception description]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
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
    
    
    [feedCell setupWithHeadline:((NewFeedsItem *)_news[indexPath.row]).headline text:((NewFeedsItem *)_news[indexPath.row]).text sourceUrlPath:((NewFeedsItem *)_news[indexPath.row]).sourceUrlPath];
    
    
    return feedCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

@end
