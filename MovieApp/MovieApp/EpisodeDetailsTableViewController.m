#import "EpisodeDetailsTableViewController.h"
#import "SeparatorTableViewCell.h"
#import "EpisodeTrailerTableViewCell.h"
#import "DataProviderService.h"
#import "BasicEpisodeInfoTableViewCell.h"
#import "RatingTableViewCell.h"
#import "OverviewTableViewCell.h"
#import "CastTableViewCell.h"
#import "CastMember.h"

#define HELVETICA_FONT @"HelveticaNeue"
#define FONT_SIZE_REGULAR 14
#define CAST_SECTION_NAME @"Cast"
#define YOUTUBE @"YouTube"
#define NUMBER_OF_SECTIONS 3
#define SEPARATOR_CELL_WIDTH_HEIGHT_RATIO 18.75
#define BASE_POSTERIMAGE_URL @"http://image.tmdb.org/t/p/w92"
#define DEFAULT_VIDEO_PLAYER_HEIGHT 220

@interface EpisodeDetailsTableViewController (){
    NSMutableArray *_cast;
}

@end

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
    [self.tableView registerNib:[UINib nibWithNibName:[CastTableViewCell cellIClassName] bundle:nil] forCellReuseIdentifier:[CastTableViewCell cellIdentifier]];
    
    self.tableView.rowHeight=UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight=44.0;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    _cast=[[NSMutableArray alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return NUMBER_OF_SECTIONS;
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
            [cell setupWithRating:self.episode.voteAverage];
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
            CastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[CastTableViewCell cellIdentifier] forIndexPath:indexPath];
            NSMutableArray *imageUrls=[[NSMutableArray alloc]init];
            NSMutableArray *names=[[NSMutableArray alloc]init];
            NSMutableArray *roles=[[NSMutableArray alloc]init];
            for(int i=0;i<4 && i<[_cast count];i++){
                CastMember *currentCastMember=_cast[i];
                if(currentCastMember.profileImageUrl && currentCastMember.name){
                    [imageUrls addObject:[NSURL URLWithString:[BASE_POSTERIMAGE_URL stringByAppendingString:currentCastMember.profileImageUrl]]];
                    [names addObject:currentCastMember.name];
                    [roles addObject:currentCastMember.character];
                }
            }
            [cell setupWithImageUrls:imageUrls correspondingNames:names roles:roles];
            return cell;
        }
        
    }
    
    return  nil;

}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if(section==0){
        return [NSString stringWithFormat:@"Season %lu Episode %lu", self.episode.seasonNumber, self.episode.episodeNumber];
    }
    
    else if(section==2){
        return CAST_SECTION_NAME;
    }
    
    else {
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        if(indexPath.row==0){
            return DEFAULT_VIDEO_PLAYER_HEIGHT;
        }
        else if(indexPath.row==3){
            return [self separatorCellHeight];
        }
    }
    
    else if(indexPath.section==1){
        if(indexPath.row==1){
            return [self separatorCellHeight];
        }
    }
    
    return UITableViewAutomaticDimension;
    
}
-(void)updateReceiverWithNewData:(NSArray *)customItemsArray info:(NSDictionary *)info{
    for(int i=0;i<[customItemsArray count];i++){
        if([customItemsArray[i] isKindOfClass:[Video class]]){
            Video *currentVideo=(Video *)customItemsArray[i];
            if([currentVideo.site isEqualToString:YOUTUBE]){
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
    return self.tableView.bounds.size.width/SEPARATOR_CELL_WIDTH_HEIGHT_RATIO;
}

@end
