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

//these ratios are calculated based on sketch file
//better solution is using UITableViewAutomaticDimension but in some cases it didnt help me
#define TRAILER_CELL_WIDTH_HEIGHT_RATIO 1.72
#define BASIC_INFO_CELL_WIDTH_HEIGHT_RATIO 7
#define SEPARATOR_CELL_WIDTH_HEIGHT_RATIO 18.75
#define CREDITS_CELL_WIDTH_HEIGHT_RATIO 5
#define IMAGES_CELL_WIDTH_HEIGHT_RATIO 2.77
#define CAST_CELL_WIDTH_HEIGHT_RATIO 1.875
#define START_POINT_X 0.5
#define START_POINT_Y 0.3
#define END_POINT_X 0.5
#define END_POINT_Y 1.0
#define BASE_IMAGE_URL @"http://image.tmdb.org/t/p/w500"
#define TYPE_DETAILS @"details"
#define TYPE_CREDITS @"credits"
#define TYPE_KEY @"type"
#define NUMBER_SECTIONS 6
#define BASE_POSTERIMAGE_URL @"http://image.tmdb.org/t/p/w92"
#define HELVETICA_FONT @"HelveticaNeue"
#define FONT_SIZE_REGULAR 14
#define SEASON_DETAILS_SEGUE_IDENTIFIER @"SeasonsDetailsSegue"
#define IMAGE_GALLERY_SECTION_NAME @"Image gallery"
#define CAST_SECTION_NAME @"Cast"
#define REVIEWS_SECTION_NAME @"Reviews"
#define TRAILER_SEGUE_IDENTIFIER @"TrailerSegue"



@interface TVEventDetailsTableViewController (){
    TVEvent *_mainTvEvent;
    TVEventDetails *_mainTvEventDetails;
    NSMutableArray *_cast;
    NSMutableArray *_crew;
    NSMutableArray *_images;
    NSMutableArray *_reviews;
    NSMutableArray *_seasons;
    BOOL _detailsLoaded;
    BOOL _creditsLoaded;
}

@end

@implementation TVEventDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configure];
    self.tableView.rowHeight=UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight=44.0;
    
    [[DataProviderService sharedDataProviderService] getDetailsForTvEvent:_mainTvEvent returnTo:self];
    [[DataProviderService sharedDataProviderService] getCreditsForTvEvent:_mainTvEvent returnTo:self];
    
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
    
    _cast=[[NSMutableArray alloc]init];
    _crew=[[NSMutableArray alloc]init];
    _images=[[NSMutableArray alloc]init];
    _reviews=[[NSMutableArray alloc]init];
    _seasons=[[NSMutableArray alloc]init];
    
    self.navigationItem.title=_mainTvEvent.title;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return NUMBER_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==0){
        return 3;
    }
    else if(section==1){
        return ([_mainTvEvent isKindOfClass:[Movie class]]) ? 4 : 6;
    }
    else if(section==2){
        return 2;
    }
    else if(section==3){
        return 2;
    }
    else if(section==4){
        return [_reviews count]==0 ? 0 : 2*[_reviews count]-1;
    }
    
    else{
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section==0){
        if(indexPath.row==0){
            TrailerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[TrailerTableViewCell cellIdentifier] forIndexPath:indexPath];
            NSURL *imageUrl=[NSURL URLWithString:[BASE_IMAGE_URL stringByAppendingString:_mainTvEvent.backdropPath ]];
            
            [cell setupCellWithTitle:_mainTvEvent.originalTitle imageUrl:imageUrl releaseYear:[_mainTvEvent getReleaseYear]];
            if(![_mainTvEvent isKindOfClass:[Movie class]]){
                [cell.playButton setHidden:YES];
            }
            [cell setDelegate:(id<ShowTrailerDelegate>)self];
            return cell;
        }
        else if(indexPath.row==1){
            BasicInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[BasicInfoTableViewCell cellIdentifier] forIndexPath:indexPath];
            
            [cell setupWithReleaseDate:[_mainTvEvent getFormattedReleaseDate] duration:78 genres:[_mainTvEvent getFormattedGenresRepresentation]];
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
            [cell setupWithDirector:[CrewMember getDirectorsNameFromArray:_crew] writers:[CrewMember getWritersFromArray:_crew] stars:[CastMember getCastStringRepresentationFromArray:_cast]];
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
            
            [cell setupWithNumberOfSeasons:[_seasons count] years:[TvShowSeason getStringOfYearsForSeasons:_seasons]];
            return cell;
            
        }
        else if(indexPath.row==3 || indexPath.row==5){
            SeparatorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[SeparatorTableViewCell cellIdentifier] forIndexPath:indexPath];
            return cell;
        }
    }
    else if(indexPath.section==2){
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
    else if(indexPath.section==3){
        if(indexPath.row==0){
            CastTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[CastTableViewCell cellIdentifier] forIndexPath:indexPath];
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
                [cell setupWithAuthorName:currentReview.author reviewText:currentReview.content readMoreURL:[NSURL URLWithString:currentReview.url]];
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
            return [self trailerCellHeight];
        }
        else if(indexPath.row==2){
            return [self separatorCellHeight];
        }
    }
    else if(indexPath.section==1){
        if(indexPath.row==1){
            return 35;
        }
        else if(indexPath.row==2){
            return UITableViewAutomaticDimension;
        }
        else if(indexPath.row==3 || indexPath.row==5 ){
            return [self separatorCellHeight];
            
        }
        
    }
    else if(indexPath.section==2){
        if(indexPath.row==0){
            return [self imageCellHeight];
        }
        else if(indexPath.row==1){
            return [self separatorCellHeight];
        }
        
    }
    else if(indexPath.section==3){
        if(indexPath.row==1){
            return [self separatorCellHeight];
        }
        
    }
    else if(indexPath.section==4){
        if(indexPath.row%2==1){
            return [self separatorCellHeight];
        }
        
    }
    
    return UITableViewAutomaticDimension;
    
}

-(CGFloat)trailerCellHeight{
    return self.tableView.bounds.size.width/TRAILER_CELL_WIDTH_HEIGHT_RATIO;
}

-(CGFloat)basicInfoCellHeight{
    return self.tableView.bounds.size.width/BASIC_INFO_CELL_WIDTH_HEIGHT_RATIO;
}

-(CGFloat)separatorCellHeight{
    return self.tableView.bounds.size.width/SEPARATOR_CELL_WIDTH_HEIGHT_RATIO;
}

-(CGFloat)imageCellHeight{
    return self.tableView.bounds.size.width/IMAGES_CELL_WIDTH_HEIGHT_RATIO;
}

-(CGFloat)castCellHeight{
    return self.tableView.bounds.size.width/CAST_CELL_WIDTH_HEIGHT_RATIO;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if(section==2){
        return IMAGE_GALLERY_SECTION_NAME;
    }
    
    else if(section==3){
        return CAST_SECTION_NAME;
    }
    
    else if(section==4){
        return REVIEWS_SECTION_NAME;
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

-(void)updateReceiverWithNewData:(NSArray *)customItemsArray info:(NSDictionary *)info{
    if([info[TYPE_KEY] isEqualToString:TYPE_DETAILS]){
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
    
    if(_detailsLoaded && _creditsLoaded){
        [self.tableView reloadData];
    }
    
}
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        [self.tableView reloadData];
        
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:SEASON_DETAILS_SEGUE_IDENTIFIER]){
        EpisodesGuideTableViewController *destinationVC=(EpisodesGuideTableViewController *)segue.destinationViewController;
        destinationVC.seasons=(NSArray *)sender;
        destinationVC.tvShow=(TVShow *)_mainTvEvent;
        destinationVC.navigationItem.title=_mainTvEvent.title;
        
    }
    else if([segue.identifier isEqualToString:TRAILER_SEGUE_IDENTIFIER]){
        TrailerViewController *destinationVC=(TrailerViewController *)segue.destinationViewController;
        destinationVC.tvEvent=_mainTvEvent;
    }
}

-(void)showSeasons{
    [self performSegueWithIdentifier:SEASON_DETAILS_SEGUE_IDENTIFIER sender:_seasons];
}

-(void)showTrailer{
    [self performSegueWithIdentifier:TRAILER_SEGUE_IDENTIFIER sender:_mainTvEvent];
}

@end
