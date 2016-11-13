#import "AppDelegate.h"
#import "Movie.h"
#import "TVShow.h"
#import "DataProviderService.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <KeychainItemWrapper.h>
#import "VirtualDataStorage.h"

#define TYPE_KEY @"type"

@interface AppDelegate (){
}

@end

@implementation AppDelegate
static DataProviderService *downloader=nil;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Fabric with:@[[Crashlytics class]]];

    KeychainItemWrapper *myKeyChain=[[KeychainItemWrapper alloc] initWithIdentifier:KeyChainItemWrapperIdentifier accessGroup:nil];
    NSString *username=[myKeyChain objectForKey:(id)kSecAttrAccount];
    
    if(username && [username length]>0){
        [[VirtualDataStorage sharedVirtualDataStorage] updateData];
    }
   
    [[DataProviderService sharedDataProviderService] getGenresForTvEvent:[Movie class] ReturnTo:self];
    [[DataProviderService sharedDataProviderService] getGenresForTvEvent:[TVShow class] ReturnTo:self];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
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
