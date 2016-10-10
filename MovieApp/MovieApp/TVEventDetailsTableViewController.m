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

//these ratios are calculated based on sketch file
//better solution is using UITableViewAutomaticDimension but in some cases it didnt help me
#define TRAILER_CELL_WIDTH_HEIGHT_RATIO 1.72
#define BASIC_INFO_CELL_WIDTH_HEIGHT_RATIO 7
#define SEPARATOR_CELL_WIDTH_HEIGHT_RATIO 18.75
#define CREDITS_CELL_WIDTH_HEIGHT_RATIO 5
#define IMAGES_CELL_WIDTH_HEIGHT_RATIO 2.77
#define START_POINT_X 0.5
#define START_POINT_Y 0.3
#define END_POINT_X 0.5
#define END_POINT_Y 1.0
#define BASE_IMAGE_URL @"http://image.tmdb.org/t/p/w500"
#define TYPE_DETAILS @"details"
#define TYPE_CREDITS @"credits"
#define TYPE_KEY @"type"
#define NUMBER_SECTIONS 3



@interface TVEventDetailsTableViewController (){
    TVEvent *_mainTvEvent;
    TVEventDetails *_mainTvEventDetails;
    NSMutableArray *_cast;
    NSMutableArray *_crew;
    NSMutableArray *_images;
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
    
    _cast=[[NSMutableArray alloc]init];
    _crew=[[NSMutableArray alloc]init];
    _images=[[NSMutableArray alloc]init];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return NUMBER_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==0){
        return 3;
    }
    else if(section==1){
        return 4;
    }
    else if(section==2){
        return 2;
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
        else{
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
        else if(indexPath.row==1){
            return [self basicInfoCellHeight];
        }
        else {
            return [self separatorCellHeight];
        }
    }
    else if(indexPath.section==1){
        if(indexPath.row==0){
            return UITableViewAutomaticDimension;
        }
        else if(indexPath.row==1){
            return 35;
        }
        else if(indexPath.row==2){
            return UITableViewAutomaticDimension;
        }
        else {
            return [self separatorCellHeight];
        }
    }
    else if(indexPath.section==2){
        if(indexPath.row==0){
            return [self imageCellHeight];
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


-(void)updateReceiverWithNewData:(NSArray *)customItemsArray info:(NSDictionary *)info{
    if([info[TYPE_KEY] isEqualToString:TYPE_DETAILS]){
        _mainTvEventDetails=customItemsArray[0];
        for(int i=1;i<[customItemsArray count];i++){
            if([customItemsArray[i] isKindOfClass:[Image class]]){
                [_images addObject:customItemsArray[i]];
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
    }
    if([_crew count]>0){
        [self.tableView reloadData];
    }
   
}


@end
