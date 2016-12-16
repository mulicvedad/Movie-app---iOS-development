#import "AppDelegate.h"
#import "Movie.h"
#import "TVShow.h"
#import "DataProviderService.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <KeychainItemWrapper.h>
#import "VirtualDataStorage.h"
#import <Realm/Realm.h>
#import "Genre.h"

#import "DatabaseManager.h"
#import <CoreSpotlight/CoreSpotlight.h>

#define TYPE_KEY @"type"

@interface AppDelegate (){
}

@end

@implementation AppDelegate
static DataProviderService *downloader=nil;
static NSString *SearchableItemMovieDomainIdentifier=@"movie";
static NSString *SearchableItemTVShowDomainIdentifier=@"tv";
static NSString *EventDetailsSegueIdentifier=@"ShowDetailsSegue";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupDatabaseMigration];
    [self setupAccount];
    [Fabric with:@[[Crashlytics class]]];
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
 
    if([MovieAppConfiguration isConnectedToInternet]){
        [[DatabaseManager sharedDatabaseManager] connectionEstablished];
        [[DataProviderService sharedDataProviderService] getGenresForTvEvent:[Movie class] ReturnTo:self];
        [[DataProviderService sharedDataProviderService] getGenresForTvEvent:[TVShow class] ReturnTo:self];        
    }
    else{
        [self setupGenres];
    }
   
    return YES;
}

-(void)updateReceiverWithNewData:(NSArray *)customItemsArray info:(NSDictionary *)info{
    if([[info objectForKey:TYPE_KEY] isEqualToString:[Movie getClassName]]){
        [Movie initializeGenres:customItemsArray];
    }
    else{
        [TVShow initializeGenres:customItemsArray];
    }
}


-(void)setupGenres{
    RLMResults *movieGenresDb=[GenreDb objectsWhere:@"isMovieGenre=YES"];
    RLMResults *tvShowGenresDb=[GenreDb objectsWhere:@"isMovieGenre=NO"];
    
    NSMutableArray *movieGenres=[[NSMutableArray alloc] init];
    NSMutableArray *tvShowGenres=[[NSMutableArray alloc] init];
    
    for(GenreDb *genreDb in movieGenresDb){
        Genre *newGenre=[[Genre alloc ]init];
        newGenre.genreID=genreDb.id;
        newGenre.genreName=genreDb.genreName;
        [movieGenres addObject:newGenre];
    }
    
    for(GenreDb *genreDb in tvShowGenresDb){
        Genre *newGenre=[[Genre alloc ]init];
        newGenre.genreID=genreDb.id;
        newGenre.genreName=genreDb.genreName;
        [tvShowGenres addObject:newGenre];
    }
    
    [Movie initializeGenres:movieGenres];
    [TVShow initializeGenres:tvShowGenres];
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    UITabBarController *mainTabBarController=(UITabBarController *)self.window.rootViewController;
    [mainTabBarController setSelectedIndex:1];
    UINavigationController *moviesNavigationVC=mainTabBarController.childViewControllers[1];
    UIViewController *moviesViewController=moviesNavigationVC.childViewControllers[0];
    
    NSUserDefaults *std=[[NSUserDefaults standardUserDefaults] initWithSuiteName:AppGroupSuiteName];
    
    NSData *movieData=[std objectForKey:SelectedMovieUserDefaultsKey];
    TVEvent *movie=[NSKeyedUnarchiver unarchiveObjectWithData:movieData];
    Movie *newMovie=[[Movie alloc] init];
    newMovie.id=movie.id;
    newMovie.title=movie.title;
    newMovie.posterPath=movie.posterPath;
    newMovie.voteAverage=movie.voteAverage;
    if([[DatabaseManager sharedDatabaseManager] containsTVEventInFavorites:newMovie]){
        newMovie.isInFavorites=YES;
    }
    else{
        newMovie.isInFavorites=NO;
    
    }
    if([[DatabaseManager sharedDatabaseManager] containsTVEventInWatchlist:newMovie]){
        newMovie.isInWatchlist=YES;
    }
    else{
        newMovie.isInWatchlist=NO;
        
    }
    [moviesViewController performSegueWithIdentifier:EventDetailsSegueIdentifier sender:newMovie];
        
    
    return YES;
}

-(BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler{
    
    UITabBarController *mainTabBarController=(UITabBarController *)self.window.rootViewController;
    UINavigationController *moviesNavigationVC=mainTabBarController.childViewControllers[1];
    UINavigationController *tvshowsNavigationVC=mainTabBarController.childViewControllers[2];
    UIWindow *moviesWindow=moviesNavigationVC.view.window;
    UIWindow *tvshowsWindow=tvshowsNavigationVC.view.window;
    
    UIViewController *viewController;
    if(moviesWindow){
        viewController=moviesNavigationVC.childViewControllers[0];
    }
    else if(tvshowsWindow){
        viewController=tvshowsNavigationVC.childViewControllers[0];
    }
    else{
        if([self mediaTypeOfUserActivity:userActivity] == MovieType){
            [mainTabBarController setSelectedIndex:1];
            viewController=moviesNavigationVC.childViewControllers[0];
        }
        else{
            [mainTabBarController setSelectedIndex:2];
            viewController=tvshowsNavigationVC.childViewControllers[0];
        }
    }

    
    [viewController restoreUserActivityState:userActivity];
    
    return YES;
}

-(MediaType)mediaTypeOfUserActivity:(NSUserActivity *)activity{
    MediaType mediaType;
    if([activity.activityType isEqualToString:CSSearchableItemActionType]){
        NSDictionary *userInfo=activity.userInfo;
        
        if(userInfo){
            NSString *identifier = [userInfo objectForKey:CSSearchableItemActivityIdentifier];
            
            NSString *numberString;
            
            NSScanner *scanner = [NSScanner scannerWithString:identifier];
            NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
            
            [scanner scanUpToCharactersFromSet:numbers intoString:NULL];
            
            [scanner scanCharactersFromSet:numbers intoString:&numberString];
            
            if ([identifier rangeOfString:SearchableItemMovieDomainIdentifier].location != NSNotFound){
                mediaType=MovieType;
            }
            else if([identifier rangeOfString:SearchableItemTVShowDomainIdentifier].location != NSNotFound){
                mediaType=TVShowType;
            }
            else{
                //error
                return -1;
            }
        }
    }
    
    return mediaType;

}

-(void)setupAccount{
    KeychainItemWrapper *myKeyChain=[[KeychainItemWrapper alloc] initWithIdentifier:KeyChainItemWrapperIdentifier accessGroup:nil];
    NSString *username=[myKeyChain objectForKey:(id)kSecAttrAccount];
    
    if(username && [username length]>0 && [MovieAppConfiguration isConnectedToInternet]){
        [[VirtualDataStorage sharedVirtualDataStorage] updateData];
    }
    else if(!username || [username length]==0){
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:TVShowsNotificationsEnabledNSUserDefaultsKey];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:MoviesNotificationsEnabledNSUserDefaultsKey];
    }

}

-(void)setupDatabaseMigration{
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    config.schemaVersion = 19;
    
    config.migrationBlock = ^(RLMMigration *migration, uint64_t oldSchemaVersion) {
        if (oldSchemaVersion < 19) {
        }
    };
    
    [RLMRealmConfiguration setDefaultConfiguration:config];
    [RLMRealm defaultRealm];
}

-(void)displayLogInfo{
    NSLog(@"REALM URL: %@",[[RLMRealm defaultRealm] configuration].fileURL);

    NSString *tmp=[NSString stringWithFormat:@"%d",__IPHONE_OS_VERSION_MAX_ALLOWED];
    NSLog(@"OS VERSION MAX ALLOWED: %@",tmp);
}

-(void)emptyDatabase{
    [[RLMRealm defaultRealm] beginWriteTransaction];
    [[RLMRealm defaultRealm] deleteAllObjects];
    [[RLMRealm defaultRealm] commitWriteTransaction];
}
@end
