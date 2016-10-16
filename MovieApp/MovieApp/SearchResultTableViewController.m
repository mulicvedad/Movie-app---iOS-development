#import "SearchResultTableViewController.h"
#import "SearchResultItemTableViewCell.h"
#import "Movie.h"
#import "TVShow.h"
#import "SearchResultItem.h"
#import "TVEventDetailsTableViewController.h"

#define  DEFAULT_RESULT_ITEM_HEIGTH 92.0
#define HELVETICA_FONT @"HelveticaNeue"
#define FONT_SIZE_REGULAR 12
#define FONT_SIZE_BIG 18
#define BASE_POSTERIMAGE_URL @"http://image.tmdb.org/t/p/w92"
#define SHOW_DETAILS_SEGUE_IDENTIFIER @"ShowDetailsSegue"

@interface SearchResultTableViewController (){
    NSMutableArray *_results;
    
}

@end

@implementation SearchResultTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configure];
}

-(void)configure{
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.tableView.backgroundColor=[MovieAppConfiguration getResultsTableViewBackgroungColor];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:[SearchResultItemTableViewCell cellIClassName] bundle:nil] forCellReuseIdentifier:[SearchResultItemTableViewCell cellIdentifier]];
    
    _results=[[NSMutableArray alloc]init];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_results count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchResultItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[SearchResultItemTableViewCell cellIdentifier] forIndexPath:indexPath];
    [cell registerDelegate:self tableViewRowNumber:indexPath.row];
    TVEvent *currentEvent=_results[indexPath.row];
    NSString *title=(currentEvent.title==nil) ? @"Name not found" : currentEvent.title;
    
    NSMutableAttributedString *titleAttributedString=[[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:[UIFont fontWithName:HELVETICA_FONT size:FONT_SIZE_BIG], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    NSMutableAttributedString *dateAttributedString;
    
    if(!currentEvent.releaseDate){
        dateAttributedString=[[NSMutableAttributedString alloc] initWithString:@""];
    }
    else{
        dateAttributedString=[[NSMutableAttributedString alloc] initWithString:
                              [[@" (" stringByAppendingString:[currentEvent getReleaseYear] ] stringByAppendingString:@")" ] attributes:@{NSFontAttributeName:[UIFont fontWithName:HELVETICA_FONT size:FONT_SIZE_REGULAR], NSForegroundColorAttributeName:[MovieAppConfiguration getPrefferedGreyColor]}];
    }
    
    if(![currentEvent isKindOfClass:[Movie class]] && currentEvent.releaseDate){
        [titleAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
    }
    [titleAttributedString appendAttributedString:dateAttributedString];
    NSURL *imageUrl=nil;
    if(currentEvent.posterPath){
        imageUrl=[NSURL URLWithString:[BASE_POSTERIMAGE_URL stringByAppendingString:currentEvent.posterPath]];
    }
    
    [cell setupWithTitle:titleAttributedString rating:currentEvent.voteAverage imageUrl:imageUrl];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return DEFAULT_RESULT_ITEM_HEIGTH;
}

-(void)updateReceiverWithNewData:(NSArray *)customItemsArray info:(NSDictionary *)info{
    [_results removeAllObjects];
    for(int i=0;i<[customItemsArray count];i++){
        SearchResultItem *currentItem=(SearchResultItem *)customItemsArray[i];
        if([currentItem.mediaType isEqualToString:@"movie"]){
            [_results addObject:[Movie movieWithSearchResultItem:currentItem]];
        }
        else{
            [_results addObject:[TVShow tvShowWithSearchResultItem:currentItem]];
            
        }
    }
    [self.tableView reloadData];
}

-(void)showTvEventDetailsForTvEventAtRow:(NSUInteger)row{
    UISearchController *parentController=(UISearchController *)self.parentViewController;
    [(UIViewController *)parentController.searchResultsUpdater performSegueWithIdentifier:SHOW_DETAILS_SEGUE_IDENTIFIER sender:_results[row]];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:SHOW_DETAILS_SEGUE_IDENTIFIER]){
        TVEventDetailsTableViewController *destinationVC=segue.destinationViewController;
        [destinationVC setMainTvEvent:sender];
    }
}

-(void)clearSearchResults{
    [_results removeAllObjects];
    [self.tableView reloadData];
}
@end
