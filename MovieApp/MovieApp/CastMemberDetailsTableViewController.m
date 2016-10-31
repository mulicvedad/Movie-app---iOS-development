#import "CastMemberDetailsTableViewController.h"
#import "DataProviderService.h"
#import "CastMemberPictureTableViewCell.h"
#import "CastMemberInfoTableViewCell.h"
#import "FilmographyTableViewCell.h"
#import "PersonDetails.h"
#import "TVEventCredit.h"
#import "ReviewSeparatorTableViewCell.h"
#import "Movie.h"
#import "TVShow.h"


@interface CastMemberDetailsTableViewController (){
    NSMutableArray *_tvEventCredits;
    PersonDetails *_personDetails;
}

@end
static NSString * const MediaTypeMovie=@"movie";
static CGFloat CastMemberPictureTableViewCellDefaultHeight=220.0f;
@implementation CastMemberDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configure];
    [[DataProviderService sharedDataProviderService] getPersonDetailsForID:self.castMember.id returnTo:self];
}

-(void)configure{
    [self.tableView registerNib:[UINib nibWithNibName:[CastMemberPictureTableViewCell cellClassName] bundle:nil] forCellReuseIdentifier:[CastMemberPictureTableViewCell cellIdentifier]];
    [self.tableView registerNib:[UINib nibWithNibName:[CastMemberInfoTableViewCell cellClassName] bundle:nil] forCellReuseIdentifier:[CastMemberInfoTableViewCell cellIdentifier]];
    [self.tableView registerNib:[UINib nibWithNibName:[FilmographyTableViewCell cellClassName] bundle:nil] forCellReuseIdentifier:[FilmographyTableViewCell cellIdentifier]];
    [self.tableView registerNib:[UINib nibWithNibName:[ReviewSeparatorTableViewCell cellIClassName] bundle:nil] forCellReuseIdentifier:[ReviewSeparatorTableViewCell cellIdentifier]];
    _tvEventCredits=[[NSMutableArray alloc]init];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section==0) ? 3 : 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==0){
        if(indexPath.row==0){
            CastMemberPictureTableViewCell *cell=[self.tableView dequeueReusableCellWithIdentifier:[CastMemberPictureTableViewCell cellIdentifier] forIndexPath:indexPath];
            [cell setupWithCastMember:self.castMember];
            return cell;
        }
        else if(indexPath.row==1){
            CastMemberInfoTableViewCell *cell=[self.tableView dequeueReusableCellWithIdentifier:[CastMemberInfoTableViewCell cellIdentifier] forIndexPath:indexPath];
            if(_personDetails){
                [cell setupWithCastMember:_personDetails];
            }
            return cell;
        }
        else{
            ReviewSeparatorTableViewCell *cell=[self.tableView dequeueReusableCellWithIdentifier:[ReviewSeparatorTableViewCell cellIdentifier] forIndexPath:indexPath];
            [cell setupForCastMemberDetails];
            return cell;

        }
    }
    else{
        FilmographyTableViewCell *cell=[self.tableView dequeueReusableCellWithIdentifier:[FilmographyTableViewCell cellIdentifier] forIndexPath:indexPath];
        if(_tvEventCredits){
            [cell setupWithTVEventCredits:_tvEventCredits delegateForSegue:self];
        }
        return cell;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        if(indexPath.row==0){
            return (self.castMember.profileImageUrl) ? CastMemberPictureTableViewCellDefaultHeight : 60;
        }
        else if(indexPath.row==2){
            return 30;
        }
    }
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        if(indexPath.row==0){
            return (self.castMember.profileImageUrl) ? CastMemberPictureTableViewCellDefaultHeight : 60;
        }
        else{
            return 280.0f;
        }
    }
    else{
        return 160.0f;
    }
}
-(void)updateReceiverWithNewData:(NSArray *)customItemsArray info:(NSDictionary *)info{
    for(int i=0;i<[customItemsArray count];i++){
        if([customItemsArray[i] isKindOfClass:[PersonDetails class]]){
            _personDetails=customItemsArray[i];
        }
        else if([customItemsArray[i] isKindOfClass:[TVEventCredit class]]){
            [_tvEventCredits addObject:customItemsArray[i]];
        }
        
    }
    [self.tableView reloadData];

}

-(void)showTvEventDetailsForTvEventAtRow:(NSUInteger)row{
    //in order to make this happen, some changes are needed in TvEventDetailsViewController
}
@end
