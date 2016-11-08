#import "SideMenuTableViewController.h"
#import "SideMenuItemTableViewCell.h"
#import <KeychainItemWrapper.h>

#define FontSize12 12

@interface SideMenuTableViewController ()

@end

static const CGFloat CellHeight=42.0f;

static const CGFloat HeaderDefaultHeight=70.0f;
static const CGFloat HeaderLabelXPosition=26.0f;
static const CGFloat HeaderLabelYPosition=25.0f;
static const CGFloat HeaderLabelHeight=20.0f;

static const CGFloat SectionHeaderDefaultHeight=36.0f;
static const CGFloat SectionHeaderLabelXPosition=26.0f;
static const CGFloat SectionHeaderLabelYPosition=8.0f;
static const CGFloat SectionHeaderLabelHeight=20.0f;
static NSString * UsersListsTableViewSectionHeaderText=@"YOUR LIST";
static NSString * MoreInfoTableViewSectionHeaderText=@"MORE";

@interface SideMenuTableViewController (){
    SideMenuOption _currentOption;
    id<SideMenuDelegate> _delegate;
}
@end
@implementation SideMenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configure];

}
-(void)setDelegate:(id<SideMenuDelegate>)delegate{
    _delegate=delegate;
}
-(void)setCurrentOption:(SideMenuOption)option{
    _currentOption=option;
}
-(void)configure{
    [self configureTableViewHeader];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SideMenuItemTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SideMenuItemTableViewCell class])];
    self.tableView.backgroundColor=[UIColor blackColor];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset=UIEdgeInsetsZero;
    self.tableView.separatorColor=[MovieAppConfiguration getPreferredDarkGreyColor];
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    if(![self isUserLoggedIn]){
            self.tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);
    }

}

-(void)configureTableViewHeader{
    if(![self isUserLoggedIn]){
        return;
    }
    KeychainItemWrapper *myKeyChain=[[KeychainItemWrapper alloc] initWithIdentifier:KeyChainItemWrapperIdentifier accessGroup:nil];
    NSString *username=[myKeyChain objectForKey:(id)kSecAttrAccount];
    UIView *newTableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, HeaderDefaultHeight )];
    newTableHeaderView.backgroundColor=[UIColor blackColor];
    UILabel *currentUserLabel=[[UILabel alloc]initWithFrame:CGRectMake(HeaderLabelXPosition, HeaderLabelYPosition, self.tableView.bounds.size.width, HeaderLabelHeight)];
    currentUserLabel.text=username;
    currentUserLabel.font=[MovieAppConfiguration getPreferredFontWithSize:16 isBold:YES];
    currentUserLabel.textColor=[MovieAppConfiguration getPrefferedGreyColor];
    [newTableHeaderView addSubview:currentUserLabel];
    self.tableView.tableHeaderView=newTableHeaderView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self isUserLoggedIn] ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(![self isUserLoggedIn]){
        return 1;
    }
    return (section==0) ? 3 : 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SideMenuItemTableViewCell *cell=[self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SideMenuItemTableViewCell class]) forIndexPath:indexPath];
    
    BOOL isSelected=NO;
    if([self optionForIndexPath:indexPath]==_currentOption){
        isSelected=YES;
    }
    [cell setupWithOption:[self optionForIndexPath:indexPath] selected:isSelected];

    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CellHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return SectionHeaderDefaultHeight;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(![self isUserLoggedIn]){
        UIView *emptyView=[[UIView alloc] initWithFrame:CGRectZero];
        return emptyView;
    }
    UIView *newHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0,0, tableView.bounds.size.width, SectionHeaderDefaultHeight)];
    newHeaderView.backgroundColor=[UIColor colorWithRed:33/255.0 green:33/255.0 blue:33/255.0 alpha:1.0];
    UILabel *sectionHeaderLabel=[[UILabel alloc] initWithFrame:CGRectMake(SectionHeaderLabelXPosition, SectionHeaderLabelYPosition, tableView.bounds.size.width-SectionHeaderLabelXPosition, SectionHeaderLabelHeight)];
    sectionHeaderLabel.textColor=[MovieAppConfiguration getPrefferedGreyColor];
    sectionHeaderLabel.font=[MovieAppConfiguration getPreferredFontWithSize:FontSize12 isBold:NO];
    if(section==0){
        
        sectionHeaderLabel.text=UsersListsTableViewSectionHeaderText;
    }
    else{
        sectionHeaderLabel.text=MoreInfoTableViewSectionHeaderText;

    }
    [newHeaderView addSubview:sectionHeaderLabel];
   
    return newHeaderView;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SideMenuItemTableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    [cell setupWithOption:[self optionForIndexPath:indexPath] selected:YES];
    [_delegate doActionForOption:[self optionForIndexPath:indexPath]];
}

-(SideMenuOption)optionForIndexPath:(NSIndexPath *)indexPath{
    if(![self isUserLoggedIn]){
        return SideMenuOptionLogin;
    }
    else if(indexPath.section==0){
        return (SideMenuOption)indexPath.row;
    }
    else{
        return indexPath.row==0 ? SideMenuOptionSettings : SideMenuOptionLogout;
    }
}


-(BOOL)isUserLoggedIn{
    KeychainItemWrapper *myKeyChain=[[KeychainItemWrapper alloc] initWithIdentifier:KeyChainItemWrapperIdentifier accessGroup:nil];
    NSString *username=[myKeyChain objectForKey:(id)kSecAttrAccount];
    if(!username  || [username length]==0){
        return NO;
    }
    else{
        return YES;
    }
}

@end
