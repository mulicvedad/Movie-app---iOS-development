#import "RatingViewController.h"
#import "Movie.h"

@interface RatingViewController (){
    CGFloat _rating;
}
@end

static NSString * RatingsSelectedImageName=@"ratings-selected";
static NSString * RatingsImageName=@"rate-this";

@implementation RatingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configure];
}

-(void)configure{
    _rating=5.0f;
    if(self.tvEvent.title){
        self.navigationItem.title=self.tvEvent.title;
        self.titleLabel.text=[@"Name: " stringByAppendingString:self.tvEvent.title];
    }
    else{
        self.navigationItem.title=EmptyString;
        self.titleLabel.text=[@"Name: " stringByAppendingString:@"Not Found"];
    }
    
    for(int i=0;i<[self.starsStackView.subviews count];i++){
        UITapGestureRecognizer *tapGestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(starsSelected:)];
        UIImageView *currentImageView=self.starsStackView.subviews[i];
        currentImageView.tag=i+1;
        [currentImageView addGestureRecognizer:tapGestureRecognizer];
        
    }
}

-(void)addedTVEventWithID:(NSUInteger)tvEventID toCollectionOfType:(SideMenuOption)typeOfCollection{
    [self notifyUserOfRatingSuccess];
}

-(void)removedTVEventWithID:(NSUInteger)tvEventID fromCollectionOfType:(SideMenuOption)typeOfCollection{
    //not allowed
}

-(void)notifyUserOfRatingSuccess{
    NSMutableAttributedString *alertTitle = [[NSMutableAttributedString alloc] initWithString:@"Rated succesfully" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    NSMutableAttributedString *alertMessage = [[NSMutableAttributedString alloc] initWithString:@"\nRating completed successfully!" attributes:@{NSForegroundColorAttributeName:[MovieAppConfiguration getPrefferedLightGreyColor],                                                   NSFontAttributeName:[MovieAppConfiguration getPreferredFontWithSize:12 isBold:NO ]}];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:EmptyString
                                                                   message:EmptyString
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert setValue:alertTitle forKey:@"attributedTitle"];
    [alert setValue:alertMessage forKey:@"attributedMessage"];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         [self.navigationController popViewControllerAnimated:YES];
                                                     }];
    UIAlertAction* rateAgainAction = [UIAlertAction actionWithTitle:@"Rate again" style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {
                                                       //reset state
                                                      }];
    
    
    [alert addAction:okAction];
    [alert addAction:rateAgainAction];
    alert.view.tintColor=[MovieAppConfiguration getPrefferedYellowColorWithOpacity:0.5f];
    UIView *subView = alert.view.subviews.firstObject;
    UIView *alertContentView = subView.subviews.firstObject;
    for (UIView *subSubView in alertContentView.subviews) {
        subSubView.backgroundColor = [MovieAppConfiguration getPreferredDarkGreyColor];
    }
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneButtonPressed:(id)sender {
    MediaType mediaType=([self.tvEvent isKindOfClass:[Movie class]]) ? MovieType : TVShowType;
    [[DataProviderService sharedDataProviderService] rateTVEventWithID:_tvEvent.id rating:_rating mediaType:mediaType responseHandler:self];
}

-(void)starsSelected:(UITapGestureRecognizer *)sender{
    for(int i=0;i<[self.starsStackView.subviews count];i++){
        UIImageView *starImageView=self.starsStackView.subviews[i];
        if(i<sender.view.tag){
            starImageView.image=[UIImage imageNamed:RatingsSelectedImageName];
        }
        else{
            starImageView.image=[UIImage imageNamed:RatingsImageName];

        }
        
    }
    
    _rating=(CGFloat)sender.view.tag;
}

@end
