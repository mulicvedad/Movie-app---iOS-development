#import "EpisodesGuideTableViewController.h"
#import "EpisodeTableViewCell.h"
#import "SeparatorTableViewCell.h"
#import "DataProviderService.h"
#import "TVShowEpisode.h"
#import "MovieAppConfiguration.h"
#import "YearTableViewCell.h"
#import "TvShowSeason.h"
#import "SeasonSelectionTableViewCell.h"
#import "SimpleCollectionViewCell.h"
#import "EpisodeDetailsTableViewController.h"

#define SEPARATOR_CELL_WIDTH_HEIGHT_RATIO 18.75f
#define EPISODE_CELL_WIDTH_HEIGHT_RATIO 4.0f
#define SIMPLE_CELL_WIDTH_HEIGHT_RATIO 8.93f
#define TABLEVIEW_CELL_INSET 24.0f
#define SEASON_SECTION_NAME @"Season"
#define HELVETICA_FONT @"HelveticaNeue"
#define FONT_SIZE_REGULAR 16
#define EPISODE_DETAILS_SEGUE_NAME @"EpisodeDetailsSegue"

#define DEFAULT_COLLECTIONVIEW_CELL_WIDTH 20.0f

@interface EpisodesGuideTableViewController (){
    NSArray *_episodes;
    NSUInteger currentSeasonIndex;
}

@end

@implementation EpisodesGuideTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configure];
    currentSeasonIndex=0;
    [[DataProviderService sharedDataProviderService] getSeasonDetailsForTvShow:_tvShow.id seasonNumber:currentSeasonIndex+1 returnTo:self];

}

-(void)configure{
    [self.tableView registerNib:[UINib nibWithNibName:[EpisodeTableViewCell cellIClassName] bundle:nil] forCellReuseIdentifier:[EpisodeTableViewCell cellIdentifier]];
    [self.tableView registerNib:[UINib nibWithNibName:[SeparatorTableViewCell cellIClassName] bundle:nil] forCellReuseIdentifier:[SeparatorTableViewCell cellIdentifier]];
    [self.tableView registerNib:[UINib nibWithNibName:[YearTableViewCell cellIClassName] bundle:nil] forCellReuseIdentifier:[YearTableViewCell cellIdentifier]];
    [self.tableView registerNib:[UINib nibWithNibName:[SeasonSelectionTableViewCell cellIClassName] bundle:nil] forCellReuseIdentifier:[SeasonSelectionTableViewCell cellIdentifier]];
    
    self.tableView.rowHeight=UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight=44.0;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==0){
        return 2;
    }
    else{
        return 2*[_episodes count]-1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==0){
        if(indexPath.row==0){
            SeasonSelectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[SeasonSelectionTableViewCell cellIdentifier] forIndexPath:indexPath];
            [cell.collectionView registerNib:[UINib nibWithNibName:[SimpleCollectionViewCell cellIClassName] bundle:nil] forCellWithReuseIdentifier:[SimpleCollectionViewCell cellIdentifier]];
            [cell.collectionView setDelegate:self];
            [cell.collectionView setDataSource:self];
            [cell.collectionView reloadData];
            return cell;
        }
        else{
            YearTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[YearTableViewCell cellIdentifier] forIndexPath:indexPath];
            cell.yearLabel.text=[((TvShowSeason *)self.seasons[currentSeasonIndex]) getReleaseYear];
            return  cell;
        }
        
    }
    else if(indexPath.section==1){
        if(_episodes){
            if(indexPath.row%2==0){
                TVShowEpisode *currentEpisode=_episodes[indexPath.row/2];
                EpisodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[EpisodeTableViewCell cellIdentifier] forIndexPath:indexPath];
                
                [cell setupWithEpisodeTitle:currentEpisode.name airDate:[currentEpisode getFormattedAirDate]  rating:currentEpisode.voteAverage ordinalNumber:indexPath.row/2+1];
                
                return cell;
            }
            else{
                SeparatorTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[SeparatorTableViewCell cellIdentifier] forIndexPath:indexPath];
                return cell;
            }
        }
        
        
    }
    return nil;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        if(indexPath.row==0){
            NSUInteger numberOfCellsInOneRow=(tableView.bounds.size.width-2*TABLEVIEW_CELL_INSET)/DEFAULT_COLLECTIONVIEW_CELL_WIDTH;
            NSUInteger numberOfRows=1;
            if([_seasons count]>=numberOfCellsInOneRow){
                numberOfRows=[_seasons count]/numberOfCellsInOneRow+1;
            }
            return numberOfRows*(DEFAULT_COLLECTIONVIEW_CELL_WIDTH+10);
        }
        return UITableViewAutomaticDimension;
    }
    else if(indexPath.section==1){
        if(indexPath.row%2==0){
            return UITableViewAutomaticDimension;

        }
        else{
            return [self separatorCellHeight];

        }
    }
    return UITableViewAutomaticDimension;
}

-(CGFloat)separatorCellHeight{
    return self.tableView.bounds.size.width/SEPARATOR_CELL_WIDTH_HEIGHT_RATIO;
}

-(CGFloat)episodeCellHeight{
    return self.tableView.bounds.size.width/EPISODE_CELL_WIDTH_HEIGHT_RATIO;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if(section==0){
        return SEASON_SECTION_NAME;
    }
    else{
        return @"";
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if([view isKindOfClass:[UITableViewHeaderFooterView class]]){
        
        UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *) view;
        tableViewHeaderFooterView.contentView.backgroundColor=[UIColor blackColor];
        tableViewHeaderFooterView.textLabel.font=[UIFont fontWithName:HELVETICA_FONT size:FONT_SIZE_REGULAR];
        tableViewHeaderFooterView.textLabel.textColor=[MovieAppConfiguration getPrefferedSectionHeadlineColor];
    }
    
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==1 && indexPath.row%2==0){
        [self performSegueWithIdentifier:EPISODE_DETAILS_SEGUE_NAME sender:_episodes[indexPath.row/2]];
    }
}

//collectionview delegate methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_seasons count];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SimpleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[SimpleCollectionViewCell cellIdentifier] forIndexPath:indexPath];
    cell.seasonNumberLabel.font=[UIFont fontWithName:HELVETICA_FONT size:FONT_SIZE_REGULAR];
    if(indexPath.row==currentSeasonIndex){
        cell.seasonNumberLabel.textColor=[MovieAppConfiguration getPrefferedYellowColor];
    }
    else{
        cell.seasonNumberLabel.textColor=[UIColor whiteColor];
    }
    cell.seasonNumberLabel.text=[NSString stringWithFormat:@"%lu",indexPath.row+1];
    
    
    return cell;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    
    return CGSizeMake(DEFAULT_COLLECTIONVIEW_CELL_WIDTH, DEFAULT_COLLECTIONVIEW_CELL_WIDTH);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1.0;
}


- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.tableView reloadData];
        
    }];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
        currentSeasonIndex=indexPath.row;
        [[DataProviderService sharedDataProviderService] getSeasonDetailsForTvShow:_tvShow.id seasonNumber:currentSeasonIndex+1 returnTo:self];
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:EPISODE_DETAILS_SEGUE_NAME]){
        EpisodeDetailsTableViewController *destinationVC=segue.destinationViewController;
        destinationVC.episode=(TVShowEpisode *)sender;
        destinationVC.navigationItem.title=self.navigationItem.title;
        destinationVC.tvShowID=_tvShow.id;

    }
}

-(void)updateReceiverWithNewData:(NSArray *)customItemsArray info:(NSDictionary *)info{
    _episodes=customItemsArray;
    [self.tableView reloadData];
}




@end
