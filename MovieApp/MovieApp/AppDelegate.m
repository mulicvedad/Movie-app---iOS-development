#import "AppDelegate.h"

@interface AppDelegate (){
}

@end

@implementation AppDelegate
static DataProviderService *downloader=nil;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    return YES;
    
}

+(DataProviderService *)sharedDownloader{
    if(!downloader){
        downloader=[[DataProviderService alloc]init];
        [downloader configure];
    }
    return downloader;
}


@end
