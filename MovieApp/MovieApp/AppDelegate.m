#import "AppDelegate.h"
#import "Movie.h"
#import "TVShow.h"
#import "DataProviderService.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <KeychainItemWrapper.h>
#define TYPE_KEY @"type"

@interface AppDelegate (){
}

@end

@implementation AppDelegate
static DataProviderService *downloader=nil;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Fabric with:@[[Crashlytics class]]];
    KeychainItemWrapper *myKeyChain=[[KeychainItemWrapper alloc] initWithIdentifier:KeyChainItemWrapperIdentifier accessGroup:nil];
    NSString *sessionID=[myKeyChain objectForKey:SessionIDKeyChainKey];
    if(!sessionID || [sessionID length]==0){
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:IsUserLoggedInNSUserDefaultsKey];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IsUserLoggedInNSUserDefaultsKey];

    }
    [[DataProviderService sharedDataProviderService] getGenresForTvEvent:[Movie class] ReturnTo:self];
    [[DataProviderService sharedDataProviderService] getGenresForTvEvent:[TVShow class] ReturnTo:self];
    
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


@end
