//
//  NewsFeedTableViewController.m
//  MovieApp
//
//  Created by user on 22/09/16.
//  Copyright © 2016 internshipABH. All rights reserved.
//

#import "NewsFeedTableViewController.h"
#import "FeedTableViewCell.h"
#import "NewFeedsItem.h"
#import "FeedDownloader.h"
#import "MovieAppConfiguration.h"

@interface NewsFeedTableViewController (){
    NSMutableArray *news;
    UISearchBar *searchBar;
    UIBarButtonItem *leftButton;
    UIBarButtonItem *rightButton;
}

@end

@implementation NewsFeedTableViewController

-(void)updateViewWithNewData:(NSMutableArray *)feedItemsArray{
    news=feedItemsArray;
    
    if([news count])
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
                                                                [self viewDidLoad];
                                                                 
                                                             }];
        
        [alert addAction:defaultAction];
        [alert addAction:reloadAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    [self.tableView reloadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    searchBar = [[UISearchBar alloc] init];
    leftButton = [[UIBarButtonItem alloc]init];
    rightButton = [[UIBarButtonItem alloc]init];
    
    searchBar.placeholder=@"Search";

    leftButton.title=@"left";
    leftButton.tintColor=[UIColor whiteColor];
    
    rightButton.title=@"right";
    rightButton.tintColor=[UIColor whiteColor];
    
    self.navigationItem.titleView = searchBar;
    self.navigationItem.leftBarButtonItem = leftButton;
    self.navigationItem.rightBarButtonItem = rightButton;
   
     [self.tableView registerNib:[UINib nibWithNibName:[FeedTableViewCell cellViewClassName] bundle:nil] forCellReuseIdentifier:[FeedTableViewCell cellIdentifier]];
    
    FeedDownloader *downloader = [[FeedDownloader alloc]init];
    
    @try {
        [downloader downloadNewsFromFeed:[MovieAppConfiguration getFeedsSourceUrlPath] andReturnTo:self];
        
    } @catch (NSException *exception) {
        [news removeAllObjects];
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:[exception description]
                                                                preferredStyle:UIAlertActionStyleDestructive];
        
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
    FeedTableViewCell *feedCell = [tableView dequeueReusableCellWithIdentifier:[FeedTableViewCell cellIdentifier]];
    
    
    [feedCell setupWithHeadline:((NewFeedsItem *)news[indexPath.row]).headline text:((NewFeedsItem *)news[indexPath.row]).text sourceUrlPath:((NewFeedsItem *)news[indexPath.row]).sourceUrlPath];

    
    return feedCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [FeedTableViewCell cellHeight];
}

@end
