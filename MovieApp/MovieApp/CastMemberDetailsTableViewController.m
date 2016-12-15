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
#import "CarouselTableViewCell.h"
#import "CarouselCollectionViewCell.h"
#import "TVEventDetailsTableViewController.h"

#import "AlertManager.h"

@interface CastMemberDetailsTableViewController (){
    NSMutableArray *_tvEventCredits;
    PersonDetails *_personDetails;
    BOOL _isCarouselCollectionViewSetup;

}

@end
static NSString * const MediaTypeMovie=@"movie";
static CGFloat CastMemberPictureTableViewCellDefaultHeight=220.0f;
static CGFloat CastMemberInfoTableViewCellDefaultHeight=280.0f;
static CGFloat CastMemberFilmographyTableViewCellDefaultHeight=160.0f;
static CGFloat SeparatorCellDefaultHeight=30.0f;
static CGFloat const DefaultCarouselHeight=180.0f;
static NSString *TVEventDetailsSegueIdentifier=@"TVEventDetailsSegue";

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
    [self.tableView registerNib:[UINib nibWithNibName:[CarouselTableViewCell cellClassName] bundle:nil] forCellReuseIdentifier:[CarouselTableViewCell cellIdentifier]];
    _tvEventCredits=[[NSMutableArray alloc]init];
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
                [cell setupWithCastMember:_personDetails delegate:self];
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
        CarouselTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[CarouselTableViewCell cellIdentifier] forIndexPath:indexPath];
        if(!_isCarouselCollectionViewSetup){
            [self setupCarouselCollectionView:cell.carouselCollectionView];
            
            _isCarouselCollectionViewSetup=YES;
        }
       
        [cell.carouselCollectionView reloadData];
        return cell;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        if(indexPath.row==0){
            return (self.castMember.profileImageUrl) ? CastMemberPictureTableViewCellDefaultHeight : 60;
        }
        else if(indexPath.row==1){
            return UITableViewAutomaticDimension;
        }
        else if(indexPath.row==2){
            return SeparatorCellDefaultHeight;
        }
    }
    return DefaultCarouselHeight;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        if(indexPath.row==0){
            return (self.castMember.profileImageUrl) ? CastMemberPictureTableViewCellDefaultHeight : 60;
        }
        else{
            return CastMemberInfoTableViewCellDefaultHeight;
        }
    }
    else{
        return CastMemberFilmographyTableViewCellDefaultHeight;
    }
}
-(void)updateReceiverWithNewData:(NSArray *)customItemsArray info:(NSDictionary *)info{
    
    if(!customItemsArray){
        [self displayNoDataWarning];
        return;
    }
    
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

//carousel collectionview delegate methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_tvEventCredits count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CarouselCollectionViewCell *carouselCell=[collectionView dequeueReusableCellWithReuseIdentifier:[CarouselCollectionViewCell cellIdentifier] forIndexPath:indexPath];
    [carouselCell setupWithTVEvent:(TVEventCredit *)_tvEventCredits[indexPath.row] castMember:self.castMember];
    return carouselCell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(82, 180);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout{
    
    return  UIEdgeInsetsMake(2, 2, 2, 2);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:TVEventDetailsSegueIdentifier sender:_tvEventCredits[indexPath.row]];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:TVEventDetailsSegueIdentifier]){
        TVEventCredit *currentCredit=sender;
        TVEvent *mainTVEvent;
        if([currentCredit.mediaType isEqualToString:MediaTypeMovie]){
            mainTVEvent=[[Movie alloc]init];
        }
        else{
            mainTVEvent=[[TVShow alloc]init];

        }
        
        mainTVEvent.id=currentCredit.id;
      
        TVEventDetailsTableViewController *destVC=segue.destinationViewController;
        [destVC setMainTvEvent:mainTVEvent dalegate:nil];;
    }
}
-(void)setNeedsReload{
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

-(void)displayNoDataWarning{
    [AlertManager displaySimpleAlertWithTitle:@"No data" description:@"\nNo data could be displayed. Check your internet connection!" displayingController:self shouldPopViewController:YES];
    /*
    NSMutableAttributedString *alertTitle = [[NSMutableAttributedString alloc] initWithString:@"No data" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    NSMutableAttributedString *alertMessage = [[NSMutableAttributedString alloc] initWithString:@"\nNo data could be displayed. Check your internet connection!" attributes:@{NSForegroundColorAttributeName:[MovieAppConfiguration getPrefferedLightGreyColor],                                                   NSFontAttributeName:[MovieAppConfiguration getPreferredFontWithSize:12 isBold:NO ]}];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:EmptyString
                                                                   message:EmptyString
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert setValue:alertTitle forKey:@"attributedTitle"];
    [alert setValue:alertMessage forKey:@"attributedMessage"];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         [self.navigationController popViewControllerAnimated:YES];
                                                     }];
    
    
    [alert addAction:okAction];
    alert.view.tintColor=[MovieAppConfiguration getPrefferedYellowColorWithOpacity:0.5f];
    UIView *subView = alert.view.subviews.firstObject;
    UIView *alertContentView = subView.subviews.firstObject;
    for (UIView *subSubView in alertContentView.subviews) {
        subSubView.backgroundColor = [MovieAppConfiguration getPreferredDarkGreyColor];
    }
    [self presentViewController:alert animated:YES completion:nil];
     */
}
@end
