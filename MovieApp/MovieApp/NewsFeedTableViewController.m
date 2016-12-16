#import "NewsFeedTableViewController.h"
#import "FeedTableViewCell.h"
#import "NewFeedsItem.h"
#import "FeedDownloader.h"
#import "DataProviderService.h"
#import "SideMenuTableViewController.h"
#import "LikedTVEventsViewController.h"
#import "LoginRequest.h"
#import <KeychainItemWrapper.h>
#import "VirtualDataStorage.h"
#import "AlertManager.h"

@interface NewsFeedTableViewController (){
    NSMutableArray *_news;
    UISearchBar *_searchBar;
    FeedDownloader *_downloader;
    
    UIViewController *_sideMenuViewController;
    UIView *_shadowView;
}

@end

static NSString * const NewsFeedNavigationItemTitle=@"News Feed";

static NSString * const RequestFailedMessage=@"Check your connection.";
static NSString * const CancelButtonTitle=@"Cancel" ;
static NSString * const TryAgainButtonTitle=@"Try again" ;
static NSString * const OKButtonTitle=@"OK" ;
static NSString * const ErrorMessageTitle=@"Error" ;

static NSString * const TextFieldPropertyName=@"_searchField";
static NSString * const EventDetailsSegueIdentifier=@"ShowDetailsSegue";
static NSString * const QueryDictionaryKey=@"query";
static NSString * const BackButtonTitle=@"Back";
static NSString * const SearchBarPlaceholder=@"Search";
static NSString * const RequestFailedMessageTitle=@"Request failed";
static NSString *LikedTVEventsSegueIdentifier=@"FeedLikedTVEventsSegue";
static NSString *LoginSegueIdentifier=@"FeedsLoginSegue";
static NSString *SettingsSegueIdentifier=@"FeedSettingsSegue";

@implementation NewsFeedTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
    _downloader = [[FeedDownloader alloc]init];
    [self startDownload];
    [self configureSwipeGestureRecogniser];
    [self.tabBarController setSelectedIndex:1];
}

-(void)configureSwipeGestureRecogniser{
    UISwipeGestureRecognizer *gestureRecogniser=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction)];
    gestureRecogniser.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:gestureRecogniser];
}
-(void)swipeAction{
    if(_sideMenuViewController){
        [self removeSideMenuViewController:_sideMenuViewController];
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:LikedTVEventsSegueIdentifier]){
        LikedTVEventsViewController *destinationVC=segue.destinationViewController;
        [destinationVC setCurrentOption:(SideMenuOption)[(NSNumber *)sender integerValue]];
        
    }
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
        //[self presentViewController:alert animated:YES completion:nil];
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
                                                     //     [myKeyChain setObject:EmptyString forKey:(id)kSecAttrAccount];
                                                          [myKeyChain resetKeychainItem];
                                                       //   [myKeyChain setObject:EmptyString forKey:(id)kSecValueData];
                                                    //      [[VirtualDataStorage sharedVirtualDataStorage] removeAllData];
                                                          
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

-(void)viewWillAppear:(BOOL)animated{
    if(_news.count==0 && [MovieAppConfiguration isConnectedToInternet]){
        [AlertManager displaySimpleAlertWithTitle:@"No data" description:@"Feed cannot be updated. Check your internet connection." displayingController:self shouldPopViewController:NO];
    }
}
@end
