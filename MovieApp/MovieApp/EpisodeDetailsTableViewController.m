#import "EpisodeDetailsTableViewController.h"
#import "SeparatorTableViewCell.h"
#import "EpisodeTrailerTableViewCell.h"
#import "DataProviderService.h"
#import "BasicEpisodeInfoTableViewCell.h"
#import "RatingTableViewCell.h"
#import "OverviewTableViewCell.h"
#import "CastMember.h"
#import "CarouselTableViewCell.h"
#import "CarouselCollectionViewCell.h"
#import "CastMemberDetailsTableViewController.h"

#define FontSize14 14
#define NumberOfSections 3

@interface EpisodeDetailsTableViewController (){
    NSMutableArray *_cast;
    BOOL _isCarouselCollectionViewSetup;

}

@end

static NSString * const CastSectionName=@"Cast";
static NSString * const HeaderTitleStringFormat=@"Season %lu Episode %lu";
static CGFloat SeparatorCellWidthHeightRatio=18.75f;
static CGFloat DefaultvideoPlayerHeight=220.0f;
static CGFloat const DefaultCarouselHeight=180.0f;
static NSString *CastMemberDetailsSegueIdentifier=@"EpisodeCastMemberDetailsSegue";

@implementation EpisodeDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configure];
    [[DataProviderService sharedDataProviderService] getVideosForTvShowID:self.tvShowID seasonNumber:self.episode.seasonNumber episodeNumber:self.episode.episodeNumber returnTo:self];
    [[DataProviderService sharedDataProviderService] getCastForTvShowID:self.tvShowID seasonNumber:self.episode.seasonNumber episodeNumber:self.episode.episodeNumber returnTo:self];
    
}

-(void)configure{
    [self.tableView registerNib:[UINib nibWithNibName:[SeparatorTableViewCell cellIClassName] bundle:nil] forCellReuseIdentifier:[SeparatorTableViewCell cellIdentifier]];
    [self.tableView registerNib:[UINib nibWithNibName:[EpisodeTrailerTableViewCell cellIClassName] bundle:nil] forCellReuseIdentifier:[EpisodeTrailerTableViewCell cellIdentifier]];
    [self.tableView registerNib:[UINib nibWithNibName:[SeparatorTableViewCell cellIClassName] bundle:nil] forCellReuseIdentifier:[SeparatorTableViewCell cellIdentifier]];
    [self.tableView registerNib:[UINib nibWithNibName:[BasicEpisodeInfoTableViewCell cellIClassName] bundle:nil] forCellReuseIdentifier:[BasicEpisodeInfoTableViewCell cellIdentifier]];
    [self.tableView registerNib:[UINib nibWithNibName:[RatingTableViewCell cellIClassName] bundle:nil] forCellReuseIdentifier:[RatingTableViewCell cellIdentifier]];
    [self.tableView registerNib:[UINib nibWithNibName:[OverviewTableViewCell cellIClassName] bundle:nil] forCellReuseIdentifier:[OverviewTableViewCell cellIdentifier]];    
    [self.tableView registerNib:[UINib nibWithNibName:[CarouselTableViewCell cellClassName] bundle:nil] forCellReuseIdentifier:[CarouselTableViewCell cellIdentifier]];
    self.tableView.rowHeight=UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight=44.0;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    _cast=[[NSMutableArray alloc]init];
}

-(void)setupCarouselCollectionView:(UICollectionView *)collectionView{
    [collectionView setDelegate:self];
    [collectionView setDataSource:self];
    [collectionView registerNib:[UINib nibWithNibName:[CarouselCollectionViewCell cellClassName] bundle:nil] forCellWithReuseIdentifier:[CarouselCollectionViewCell cellIdentifier]];
    UICollectionViewFlowLayout *carouselFlowLayout=[[UICollectionViewFlowLayout alloc]init];
    carouselFlowLayout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    [collectionView setCollectionViewLayout:carouselFlowLayout];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return NumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==0){
        return 4;
    }
    else if(section==1){
        return 2;
    }
    else if(section==2){
        return 1;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==0){
        if(indexPath.row==0){
            EpisodeTrailerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[EpisodeTrailerTableViewCell cellIdentifier] forIndexPath:indexPath];
            if(self.trailer){
                [cell setupWithVideo:self.trailer];
            }
            return cell;
        }
        else if(indexPath.row==1){
             BasicEpisodeInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[BasicEpisodeInfoTableViewCell cellIdentifier] forIndexPath:indexPath];
            [cell setupWithTitle:self.episode.name airDate:[self.episode getFormattedAirDate]];
            return cell;
        }
        else if(indexPath.row==2){
            RatingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[RatingTableViewCell cellIdentifier] forIndexPath:indexPath];
            [cell setupWithRating:self.episode.voteAverage delegate:self];
            [cell hideRating];
            return cell;
        }
        else{
            SeparatorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[SeparatorTableViewCell cellIdentifier] forIndexPath:indexPath];
            
            return cell;
        }
    }
    else if(indexPath.section==1){
        if(indexPath.row==0){
            OverviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[OverviewTableViewCell cellIdentifier] forIndexPath:indexPath];
            [cell setupWithOverview:self.episode.overview];
            return cell;
        }
        else{
            SeparatorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[SeparatorTableViewCell cellIdentifier] forIndexPath:indexPath];
            
            
            return cell;
        }
        
    }
    else if(indexPath.section==2){
       if(indexPath.row==0){
           CarouselTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[CarouselTableViewCell cellIdentifier] forIndexPath:indexPath];
           if(!_isCarouselCollectionViewSetup){
               [self setupCarouselCollectionView:cell.carouselCollectionView];
               
               _isCarouselCollectionViewSetup=YES;
           }
          
           [cell.carouselCollectionView reloadData];
           return cell;
        }
        
    }
    
    return  nil;

}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if(section==0){
        return [NSString stringWithFormat:HeaderTitleStringFormat, self.episode.seasonNumber, self.episode.episodeNumber];
    }
    
    else if(section==2){
        return CastSectionName;
    }
    
    else {
        return EmptyString;
    }
   
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if([view isKindOfClass:[UITableViewHeaderFooterView class]]){
        
        UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *) view;
        tableViewHeaderFooterView.contentView.backgroundColor=[UIColor blackColor];
        tableViewHeaderFooterView.textLabel.font=[MovieAppConfiguration getPreferredFontWithSize:FontSize14 isBold:NO];
        tableViewHeaderFooterView.textLabel.textColor=[MovieAppConfiguration getPrefferedSectionHeadlineColor];
    }
    
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        if(indexPath.row==0){
            if(!self.trailer){
                return 0;
            }
            else{
               return DefaultvideoPlayerHeight;
            }
        }
        else if(indexPath.row==3){
            return [self separatorCellHeight];
        }
    }
    
    else if(indexPath.section==1){
        if(indexPath.row==0){
            return UITableViewAutomaticDimension;
        }
        else if(indexPath.row==1){
            return [self separatorCellHeight];
        }
    }
    else if(indexPath.section==2){
        if(indexPath.row==0){
            return DefaultCarouselHeight;
        }
    }
    
    return UITableViewAutomaticDimension;
    
}
-(void)updateReceiverWithNewData:(NSArray *)customItemsArray info:(NSDictionary *)info{
    for(int i=0;i<[customItemsArray count];i++){
        if([customItemsArray[i] isKindOfClass:[Video class]]){
            Video *currentVideo=(Video *)customItemsArray[i];
            if([currentVideo.site isEqualToString:YouTubeSiteName]){
                self.trailer=customItemsArray[i];
                break;
            }
        }
        else if([customItemsArray[i] isKindOfClass:[CastMember class]]){
            [_cast addObject:customItemsArray[i]];
        }
    }
    [self.tableView reloadData];
}

-(CGFloat)separatorCellHeight{
    return self.tableView.bounds.size.width/SeparatorCellWidthHeightRatio;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:CastMemberDetailsSegueIdentifier]){
        
        CastMemberDetailsTableViewController *destinationVC=(CastMemberDetailsTableViewController *)segue.destinationViewController;
        destinationVC.castMember=(CastMember *)sender;
    }
}

//carousel collection view delegate methods
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_cast count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CarouselCollectionViewCell *carouselCell=[collectionView dequeueReusableCellWithReuseIdentifier:[CarouselCollectionViewCell cellIdentifier] forIndexPath:indexPath];
    [carouselCell setupWithCastMember:_cast[indexPath.row]];
    return carouselCell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(82, 180);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout{
    
    return  UIEdgeInsetsMake(2, 2, 2, 2);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:CastMemberDetailsSegueIdentifier sender:_cast[indexPath.row]];
}

@end
