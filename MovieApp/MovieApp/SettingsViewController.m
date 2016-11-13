#import "SettingsViewController.h"
#import "LocalNotificationManagerOldVersion.h"
#import "DataProviderService.h"
#import "AccountDetails.h"

@interface SettingsViewController (){
    BOOL _movieNotificationsEnabled;
    BOOL _tvShowNotificationsEnabled;
}

@end
static NSString *ActiveToggleImageName=@"toggle-active";
static NSString *InactiveToggleImageName=@"toggle-inactive";

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configure];
    [[DataProviderService sharedDataProviderService] getAccountDetailsReturnTo:self];
    
}
-(void)configure{
    UITapGestureRecognizer *tapRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapMovieNotificationsToggle)];
    [self.movieNotificationsToggleImageView addGestureRecognizer:tapRecognizer];
    tapRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapTVShowNotificationsToggle)];
    [self.tvShowNotificationsToggleImageView addGestureRecognizer:tapRecognizer];
}

-(void)didTapMovieNotificationsToggle{
    if(_movieNotificationsEnabled){
        self.movieNotificationsToggleImageView.image=[UIImage imageNamed:InactiveToggleImageName];
        [[LocalNotificationManagerOldVersion sharedNotificationManager] removeAllNotificationsForMovies];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:MoviesNotificationsEnabledNSUserDefaultsKey];
        
    }
    else{
        self.movieNotificationsToggleImageView.image=[UIImage imageNamed:ActiveToggleImageName];
        [[LocalNotificationManagerOldVersion sharedNotificationManager] scheduleMoviesNotifications];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:MoviesNotificationsEnabledNSUserDefaultsKey];


    }
    _movieNotificationsEnabled=!_movieNotificationsEnabled;

}

-(void)didTapTVShowNotificationsToggle{
    if(_tvShowNotificationsEnabled){
        self.tvShowNotificationsToggleImageView.image=[UIImage imageNamed:InactiveToggleImageName];
        [[LocalNotificationManagerOldVersion sharedNotificationManager] removeAllNotificationsForTVShows];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:TVShowsNotificationsEnabledNSUserDefaultsKey];

    }
    else{
        self.tvShowNotificationsToggleImageView.image=[UIImage imageNamed:ActiveToggleImageName];
        [[LocalNotificationManagerOldVersion sharedNotificationManager] scheduleTVShowsNotifications];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:TVShowsNotificationsEnabledNSUserDefaultsKey];

    }
    _tvShowNotificationsEnabled=!_tvShowNotificationsEnabled;
}

-(void)updateReceiverWithNewData:(NSArray *)customItemsArray info:(NSDictionary *)info{
    AccountDetails *accDetails=customItemsArray[0];
    self.nameLabel.text=[accDetails.name length]==0 ? @"Not found" : accDetails.name;
    self.usernameLabel.text=accDetails.username;
}
@end
