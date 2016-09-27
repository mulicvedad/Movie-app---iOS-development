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

@interface NewsFeedTableViewController (){
    NSMutableArray *news;
}

@end

@implementation NewsFeedTableViewController

-(void)updateViewWithNewData:(NSMutableArray *)feedItemsArray{
    news=feedItemsArray;
    
    if(![news count])
    {
        [news addObject:[[NewFeedsItem alloc] initWithHeadline:@"nema" andWithText:@"rezultat" andWithWebPage:@"sry"]];
    }
    [self.tableView reloadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     //hardcoded items
     news = [[NSMutableArray alloc] init];
    
    NewFeedsItem *item = [[NewFeedsItem alloc] initWithHeadline:@"Testni naslov" andWithText:@"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda." andWithWebPage:@"www.klix.ba"];
    
    for(int i=0;i<5;i++){
        [news addObject:item];
    }
     */
   
     [self.tableView registerNib:[UINib nibWithNibName:@"FeedTableViewCell" bundle:nil] forCellReuseIdentifier:[FeedTableViewCell cellIdentifier]];
    
    FeedDownloader *downloader = [[FeedDownloader alloc]init];
    
    //using hardcoded and known url to check if everything is working
    // will be changed to http://www.boxofficemojo.com/about/rss.htm
    
    NSURL *feedUrl=[NSURL URLWithString:@"http://images.apple.com/main/rss/hotnews/hotnews.rss"];
    
    [downloader downloadNewsFromFeed:feedUrl andReturnTo:self];
    
    
        
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    if(!feedCell)
    {
       
        feedCell = [tableView dequeueReusableCellWithIdentifier:@"feedCell"];

    }
    
    feedCell.labelHeadline.text = ((NewFeedsItem *)news[indexPath.row]).headline;
    feedCell.textViewText.text = ((NewFeedsItem *)news[indexPath.row]).text;
    feedCell.textViewWebPage.text = ((NewFeedsItem *)news[indexPath.row]).webPage;
    
    
    
    return feedCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [FeedTableViewCell cellHeight];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
