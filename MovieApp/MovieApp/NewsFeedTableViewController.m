#import "NewsFeedTableViewController.h"
#import "FeedTableViewCell.h"
#import "NewFeedsItem.h"
#import "FeedDownloader.h"
#import "MovieAppConfiguration.h"

#define TEXT_FIELD_PROPERTY_NAME @"_searchField"

@interface NewsFeedTableViewController (){
    NSMutableArray *news;
    UISearchBar *searchBar;
    UIBarButtonItem *leftButton;
    UIBarButtonItem *rightButton;
    FeedDownloader *downloader;
}

@end

@implementation NewsFeedTableViewController

-(void)updateReceiverWithNewData:(NSMutableArray *)customItemsArray info:(NSDictionary *)info{
    news=customItemsArray;
    
    if(![news count])
    {
        if(!news)
        {
            news = [[NSMutableArray alloc] init];
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
    
    downloader = [[FeedDownloader alloc]init] ;
    [self startDownload];
}

-(void)configureView{
    [self.tableView registerNib:[UINib nibWithNibName:[FeedTableViewCell cellViewClassName] bundle:nil] forCellReuseIdentifier:[FeedTableViewCell cellIdentifier]];
    
    searchBar = [[UISearchBar alloc] init];
    searchBar.placeholder=@"Search";
    UITextField *searchTextField = [searchBar valueForKey:TEXT_FIELD_PROPERTY_NAME];
    searchTextField.backgroundColor = [UIColor darkGrayColor];
    self.navigationItem.titleView = searchBar;
}

-(void)startDownload{
    
    @try {
        [downloader downloadNewsFromFeed:[MovieAppConfiguration getFeedsSourceUrlPath] andReturnTo:self];
        
    } @catch (NSException *exception) {
        [news removeAllObjects];
        
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
    return [news count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedTableViewCell *feedCell = [tableView dequeueReusableCellWithIdentifier:[FeedTableViewCell cellIdentifier] forIndexPath:indexPath];
    
    
    [feedCell setupWithHeadline:((NewFeedsItem *)news[indexPath.row]).headline text:((NewFeedsItem *)news[indexPath.row]).text sourceUrlPath:((NewFeedsItem *)news[indexPath.row]).sourceUrlPath];

    
    return feedCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [FeedTableViewCell cellHeight];
}

@end
