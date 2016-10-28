#import "TVEventDetailsTableViewController.h"
#import "TrailerTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "BasicInfoTableViewCell.h"
#import "Genre.h"
#import "SeparatorTableViewCell.h"
#import "MovieDetails.h"
#import "DataProviderService.h"
#import "CastMember.h"
#import "CrewMember.h"
#import "TVEventCreditsTableViewCell.h"
#import "RatingTableViewCell.h"
#import "OverviewTableViewCell.h"
#import "ImagesTableViewCell.h"
#import "Image.h"
#import "CastTableViewCell.h"
#import "AlternativeCastTableViewCell.h"
#import "ReviewsTableViewCell.h"
#import "TVEventReview.h"
#import "ReviewSeparatorTableViewCell.h"
#import "SeasonsTableViewCell.h"
#import "Movie.h"
#import "TVShowDetails.h"
#import "EpisodesGuideTableViewController.h"
#import "TrailerViewController.h"
#import "Video.h"


#define NumberOfSections 6
#define FontSize14 14

@interface TVEventDetailsTableViewController (){
    TVEvent *_mainTvEvent;
    TVEventDetails *_mainTvEventDetails;
    Video *_trailer;
    NSMutableArray *_cast;
    NSMutableArray *_crew;
    NSMutableArray *_images;
    NSMutableArray *_reviews;
    NSMutableArray *_seasons;
    BOOL _detailsLoaded;
    BOOL _creditsLoaded;
    BOOL _videoLoaded;
}

@end

static NSString * const SeasonDetailsSegueIdentifier=@"SeasonsDetailsSegue";
static NSString * const TrailerSegueIdentifier=@"TrailerSegue";
static NSString * const ImageGallerySectionName=@" Image gallery";
static NSString * const CastSectionName=@" Cast";
static NSString * const ReviewsSectionName=@" Reviews";
static CGFloat const TrailerCellWidthHeightRatio=1.72f;
static CGFloat const BasicInfoCellWidthHeightRatio=7.f;
static CGFloat const SeparatorCellWidthHeightRatio=18.75f;
static CGFloat const CreditsCellWidthHeightRatio=5.f;
static CGFloat const ImagesCellWidthHeightRatio=2.77f;
static CGFloat const CastCellWidthHeightRatio=1.875f;

@implementation TVEventDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configure];
    self.tableView.rowHeight=UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight=44.0;
    
    [[DataProviderService sharedDataProviderService] getDetailsForTvEvent:_mainTvEvent returnTo:self];
    [[DataProviderService sharedDataProviderService] getCreditsForTvEvent:_mainTvEvent returnTo:self];
    if([_mainTvEvent isKindOfClass:[Movie class]]){
        [[DataProviderService sharedDataProviderService] getVideosForTvEventID:_mainTvEvent.id returnTo:self];
    }
    
}

-(void)configure{
    [self.tableView registerNib:[UINib nibWithNibName:[TrailerTableViewCell cellIClassName] bundle:nil] forCellReuseIdentifier:[TrailerTableViewCell cellIdentifier]];
    [self.tableView registerNib:[UINib nibWithNibName:[BasicInfoTableViewCell cellIClassName] bundle:nil] forCellReuseIdentifier:[BasicInfoTableViewCell cellIdentifier]];
    [self.tableView registerNib:[UINib nibWithNibName:[SeparatorTableViewCell cellIClassName] bundle:nil] forCellReuseIdentifier:[SeparatorTableViewCell cellIdentifier]];
    [self.tableView registerNib:[UINib nibWithNibName:[TVEventCreditsTableViewCell cellIClassName] bundle:nil] forCellReuseIdentifier:[TVEventCreditsTableViewCell cellIdentifier]];
    [self.tableView registerNib:[UINib nibWithNibName:[RatingTableViewCell cellIClassName] bundle:nil] forCellReuseIdentifier:[RatingTableViewCell cellIdentifier]];
    [self.tableView registerNib:[UINib nibWithNibName:[OverviewTableViewCell cellIClassName] bundle:nil] forCellReuseIdentifier:[OverviewTableViewCell cellIdentifier]];
    [self.tableView registerNib:[UINib nibWithNibName:[ImagesTableViewCell cellIClassName] bundle:nil] forCellReuseIdentifier:[ImagesTableViewCell cellIdentifier]];
    [self.tableView registerNib:[UINib nibWithNibName:[CastTableViewCell cellIClassName] bundle:nil] forCellReuseIdentifier:[CastTableViewCell cellIdentifier]];
    [self.tableView registerNib:[UINib nibWithNibName:[AlternativeCastTableViewCell cellIClassName] bundle:nil] forCellReuseIdentifier:[AlternativeCastTableViewCell cellIdentifier]];
    [self.tableView registerNib:[UINib nibWithNibName:[ReviewsTableViewCell cellIClassName] bundle:nil] forCellReuseIdentifier:[ReviewsTableViewCell cellIdentifier]];
    [self.tableView registerNib:[UINib nibWithNibName:[ReviewSeparatorTableViewCell cellIClassName] bundle:nil] forCellReuseIdentifier:[ReviewSeparatorTableViewCell cellIdentifier]];
    [self.tableView registerNib:[UINib nibWithNibName:[SeasonsTableViewCell cellIClassName] bundle:nil] forCellReuseIdentifier:[SeasonsTableViewCell cellIdentifier]];
    
    _detailsLoaded=NO;
    _creditsLoaded=NO;
    
    self.edgesForExtendedLayout=UIRectEdgeNone;

    
    _cast=[[NSMutableArray alloc]init];
    _crew=[[NSMutableArray alloc]init];
    _images=[[NSMutableArray alloc]init];
    _reviews=[[NSMutableArray alloc]init];
    _seasons=[[NSMutableArray alloc]init];
    
    self.navigationItem.title=_mainTvEvent.title;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return NumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==0){
        return 3;
    }
    else if(section==1){
        return ([_mainTvEvent isKindOfClass:[Movie class]]) ? 4 : 6;
    }
    else if(section==2 && [_images count]>0){
        return 2;
    }
    else if(section==3 && [_cast count]>0){
        return 2;
    }
    else if(section==4 &&  [_reviews count]>0){
        return 2*[_reviews count]-1;
    }
    
    else{
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section==0){
        if(indexPath.row==0){ //setup with maintvevent
            TrailerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[TrailerTableViewCell cellIdentifier] forIndexPath:indexPath];
            [cell setupWithTVEvent:_mainTvEvent];
            [cell setDelegate:(id<ShowTrailerDelegate>)self];
            return cell;
        }
        else if(indexPath.row==1){
            BasicInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[BasicInfoTableViewCell cellIdentifier] forIndexPath:indexPath];
            
            [cell setupWithReleaseDate:[_mainTvEvent getFormattedReleaseDate] duration:_mainTvEventDetails.duration genres:[_mainTvEvent getFormattedGenresRepresentation]];
            return cell;
            
        }
        else{
            SeparatorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[SeparatorTableViewCell cellIdentifier] forIndexPath:indexPath];
            return cell;
        }
        
    }
    else if(indexPath.section==1){
        if(indexPath.row==0){
            TVEventCreditsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[TVEventCreditsTableViewCell cellIdentifier] forIndexPath:indexPath];
            [cell setupWithCrew:_crew cast:_cast];
            return cell;
        }
        else if(indexPath.row==1){
            RatingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[RatingTableViewCell cellIdentifier] forIndexPath:indexPath];
            
            [cell setupWithRating:_mainTvEvent.voteAverage];
            return cell;
            
        }
        else if(indexPath.row==2){
            OverviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[OverviewTableViewCell cellIdentifier] forIndexPath:indexPath];
            
            [cell setupWithOverview:_mainTvEvent.overview];
            return cell;
            
        }
        else if(indexPath.row==4){
            
            SeasonsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[SeasonsTableViewCell cellIdentifier] forIndexPath:indexPath];
            if(!_seasons){
                return cell;
            }
            [cell registerDelegate:self];
            [cell setupWithSeasons:_seasons];
            return cell;
            
        }
        else if(indexPath.row==3 || indexPath.row==5){
            SeparatorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[SeparatorTableViewCell cellIdentifier] forIndexPath:indexPath];
            return cell;
        }
    }
    else if(indexPath.section==2){//replace by carousel
        if(indexPath.row==0){
            ImagesTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[ImagesTableViewCell cellIdentifier] forIndexPath:indexPath];
            if([_images count]>0){
                [cell setupWithUrls:[Image getURLsFromImagesArray:_images]];
            }
            return cell;
        }
        else{
            SeparatorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[SeparatorTableViewCell cellIdentifier] forIndexPath:indexPath];
            return cell;
        }
    }
    else if(indexPath.section==3){//replace by carousel
        if(indexPath.row==0){
            CastTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[CastTableViewCell cellIdentifier] forIndexPath:indexPath];
            NSMutableArray *imageUrls=[[NSMutableArray alloc]init];
            NSMutableArray *names=[[NSMutableArray alloc]init];
            NSMutableArray *roles=[[NSMutableArray alloc]init];
            for(int i=0;i<[_cast count];i++){
                CastMember *currentCastMember=_cast[i];
                if(currentCastMember.profileImageUrl && currentCastMember.name && currentCastMember.character){
                    [imageUrls addObject:[NSURL URLWithString:[BaseImageUrlForWidth92 stringByAppendingString:currentCastMember.profileImageUrl]]];
                    [names addObject:currentCastMember.name];
                    [roles addObject:currentCastMember.character];
                }
            }
            [cell setupWithImageUrls:imageUrls correspondingNames:names roles:roles];
            return cell;
        }
        else{
            SeparatorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[SeparatorTableViewCell cellIdentifier] forIndexPath:indexPath];
            return cell;
        }
    }
    else if(indexPath.section==4){
        if(indexPath.row<2*[_reviews count]){
            if(indexPath.row%2==0){
                ReviewsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[ReviewsTableViewCell cellIdentifier] forIndexPath:indexPath];
                TVEventReview *currentReview=(TVEventReview *)_reviews[indexPath.row/2];
                [cell setupWithReview:currentReview];
                return cell;
            }
            else{
                ReviewSeparatorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ReviewSeparatorTableViewCell cellIdentifier] forIndexPath:indexPath];
                return cell;
            }
            
        }
        else{
            SeparatorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[SeparatorTableViewCell cellIdentifier] forIndexPath:indexPath];
            return cell;
        }
    }
    
    return nil;
}

-(void)setMainTvEvent:(TVEvent *)tvEvent{
    if(tvEvent){
        _mainTvEvent=tvEvent;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        if(indexPath.row==0){
            if(_mainTvEvent.backdropPath){
                return [self getHeightForCellWithDivisor:TrailerCellWidthHeightRatio];

            }
            else{
                return 80;
            }
        }
        else if(indexPath.row==2){
            return [self getHeightForCellWithDivisor:SeparatorCellWidthHeightRatio];
        }
    }
    else if(indexPath.section==1){
        if(indexPath.row==1){
            return 35;
        }
        else if(indexPath.row==2){
            return UITableViewAutomaticDimension;
        }
        else if((indexPath.row==3 || indexPath.row==5) && [_images count]>0 ){
            return [self getHeightForCellWithDivisor:SeparatorCellWidthHeightRatio];
            
        }
        else if(indexPath.row==4 && [_seasons count]==0){
            return 0;
        }
        
    }
    else if(indexPath.section==2){
        if([_images count]==0){
            return 0;
        }
        else if(indexPath.row==0){
            return [self getHeightForCellWithDivisor:ImagesCellWidthHeightRatio];
        }
        else if(indexPath.row==1){
            return [self getHeightForCellWithDivisor:SeparatorCellWidthHeightRatio];
        }
        
    }
    else if(indexPath.section==3){
        if([_cast count]==0){
            return 0;
        }
        else if(indexPath.row==1){
            return [self getHeightForCellWithDivisor:SeparatorCellWidthHeightRatio];
        }
        
    }
    else if(indexPath.section==4){
        if([_reviews count]==0){
            return 0;
        }
        if(indexPath.row%2==1){
            return [self getHeightForCellWithDivisor:SeparatorCellWidthHeightRatio];
        }
        
    }
    
    return UITableViewAutomaticDimension;
    
}

-(CGFloat)getHeightForCellWithDivisor:(CGFloat)divisor{
    return self.tableView.bounds.size.width/divisor;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if(section==2 && [_images count]>0){
        return ImageGallerySectionName;
    }
    
    else if(section==3 && [_cast count]>0){
        return CastSectionName;
    }
    
    else if(section==4 && [_reviews count]>0){
        return ReviewsSectionName;
    }
    else{
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

-(void)updateReceiverWithNewData:(NSArray *)customItemsArray info:(NSDictionary *)info{
    if([customItemsArray count]>0){
        if([info[TypeDictionaryKey] isEqualToString:DetailsDictionaryValue]){
            _mainTvEventDetails=customItemsArray[0];
            for(int i=1;i<[customItemsArray count];i++){
                if([customItemsArray[i] isKindOfClass:[Image class]]){
                    [_images addObject:customItemsArray[i]];
                }
                else if([customItemsArray[i] isKindOfClass:[TVEventReview class]]){
                    [_reviews addObject:customItemsArray[i]];
                }
                else if([customItemsArray[i] isKindOfClass:[TvShowSeason class]]){
                    [_seasons addObject:customItemsArray[i]];
                }
            }
            _detailsLoaded=YES;
        }
        else if([customItemsArray[0] isKindOfClass:[Video class]]){
            for(int i=0;i<[customItemsArray count];i++){
                if([customItemsArray[i] isKindOfClass:[Video class]]){
                    if([((Video *)customItemsArray[i]).site isEqualToString:@"YouTube"]){
                        TrailerTableViewCell *cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                        cell.playButton.hidden=NO;
                        _trailer=customItemsArray[i];

                    }
                
                }
            }
            
        }
        else{
            for(int i=0;i<[customItemsArray count];i++){
                if([customItemsArray[i] isKindOfClass:[CrewMember class]]){
                    [_crew addObject:customItemsArray[i]];
                    
                }
                else if([customItemsArray[i] isKindOfClass:[CastMember class]]){
                    [_cast addObject:customItemsArray[i]];
                    
                }
                
                
            }
            _creditsLoaded=YES;
        }
    }
    
    [self.tableView reloadData];
    
}
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        [self.tableView reloadData];
        
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:SeasonDetailsSegueIdentifier]){
        EpisodesGuideTableViewController *destinationVC=(EpisodesGuideTableViewController *)segue.destinationViewController;
        destinationVC.seasons=(NSArray *)sender;
        destinationVC.tvShow=(TVShow *)_mainTvEvent;
        destinationVC.navigationItem.title=_mainTvEvent.title;
        
    }
    else if([segue.identifier isEqualToString:TrailerSegueIdentifier]){
        TrailerViewController *destinationVC=(TrailerViewController *)segue.destinationViewController;
        destinationVC.tvEvent=_mainTvEvent;
        destinationVC.video=_trailer;
    }
}

-(void)showSeasons{
    [self performSegueWithIdentifier:SeasonDetailsSegueIdentifier sender:_seasons];
}

-(void)showTrailer{
    [self performSegueWithIdentifier:TrailerSegueIdentifier sender:nil];
}

@end
