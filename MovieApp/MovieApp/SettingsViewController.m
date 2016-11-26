#import "SettingsViewController.h"
#import "DataProviderService.h"
#import "LocalNotificationHandler.h"
#import "AccountDetails.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
#import "LocalNotificationManager.h"
#else
#import "LocalNotificationManagerOldVersion.h"
#endif

@interface SettingsViewController (){
    BOOL _movieNotificationsEnabled;
    BOOL _tvShowNotificationsEnabled;
    id<LocalNotificationHandler> _notificationHandler;
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
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
    _notificationHandler=[LocalNotificationManager sharedNotificationManager];
#else
    _notificationHandler=[LocalNotificationManagerOldVersion sharedNotificationManager];
#endif
    
    _movieNotificationsEnabled=[[NSUserDefaults standardUserDefaults] boolForKey:MoviesNotificationsEnabledNSUserDefaultsKey];
    _tvShowNotificationsEnabled=[[NSUserDefaults standardUserDefaults] boolForKey:TVShowsNotificationsEnabledNSUserDefaultsKey];
    if(_movieNotificationsEnabled){
        self.movieNotificationsToggleImageView.image=[UIImage imageNamed:ActiveToggleImageName];
    }
    else{
        self.movieNotificationsToggleImageView.image=[UIImage imageNamed:InactiveToggleImageName];
    }
    if(_tvShowNotificationsEnabled){
        self.tvShowNotificationsToggleImageView.image=[UIImage imageNamed:ActiveToggleImageName];
    }
    else{
        self.tvShowNotificationsToggleImageView.image=[UIImage imageNamed:InactiveToggleImageName];
    }
}

-(void)didTapMovieNotificationsToggle{
    if(_movieNotificationsEnabled){
        self.movieNotificationsToggleImageView.image=[UIImage imageNamed:InactiveToggleImageName];
        [_notificationHandler removeAllNotificationsForMovies];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:MoviesNotificationsEnabledNSUserDefaultsKey];
        
    }
    else{
        self.movieNotificationsToggleImageView.image=[UIImage imageNamed:ActiveToggleImageName];
        [_notificationHandler scheduleTestNotifications];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:MoviesNotificationsEnabledNSUserDefaultsKey];


    }
    _movieNotificationsEnabled=!_movieNotificationsEnabled;

}

-(void)didTapTVShowNotificationsToggle{
    if(_tvShowNotificationsEnabled){
        self.tvShowNotificationsToggleImageView.image=[UIImage imageNamed:InactiveToggleImageName];
        [_notificationHandler removeAllNotificationsForTVShows];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:TVShowsNotificationsEnabledNSUserDefaultsKey];

    }
    else{
        self.tvShowNotificationsToggleImageView.image=[UIImage imageNamed:ActiveToggleImageName];
        [_notificationHandler scheduleTestNotifications];
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
