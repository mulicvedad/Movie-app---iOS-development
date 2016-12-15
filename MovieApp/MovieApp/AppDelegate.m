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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    // Set the new schema version. This must be greater than the previously used
    // version (if you've never set a schema version before, the version is 0).
    config.schemaVersion = 19;
    
    // Set the block which will be called automatically when opening a Realm with a
    // schema version lower than the one set above
    config.migrationBlock = ^(RLMMigration *migration, uint64_t oldSchemaVersion) {
        // We haven’t migrated anything yet, so oldSchemaVersion == 0
        if (oldSchemaVersion < 19) {
            // Nothing to do!
            // Realm will automatically detect new properties and removed properties
            // And will update the schema on disk automatically
        }
    };
    
    // Tell Realm to use this new configuration object for the default Realm
    [RLMRealmConfiguration setDefaultConfiguration:config];
    
    // Now that we've told Realm how to handle the schema change, opening the file
    // will automatically perform the migration
    
    NSLog(@"BASE: %@",[[RLMRealm defaultRealm] configuration].fileURL);
    
    [Fabric with:@[[Crashlytics class]]];

    KeychainItemWrapper *myKeyChain=[[KeychainItemWrapper alloc] initWithIdentifier:KeyChainItemWrapperIdentifier accessGroup:nil];
    NSString *username=[myKeyChain objectForKey:(id)kSecAttrAccount];
    
    if(username && [username length]>0 && [MovieAppConfiguration isConnectedToInternet]){
        [[VirtualDataStorage sharedVirtualDataStorage] updateData];
    }
    else if(!username || [username length]==0){
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:TVShowsNotificationsEnabledNSUserDefaultsKey];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:MoviesNotificationsEnabledNSUserDefaultsKey];
    }
    NSString *tmp=[NSString stringWithFormat:@"%d",__IPHONE_OS_VERSION_MAX_ALLOWED];
    NSLog(@"%@",tmp);
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
                return -1;
            }
        }
    }
    
    return mediaType;

}
@end
