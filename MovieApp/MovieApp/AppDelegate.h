#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "ItemsArrayReceiver.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, ItemsArrayReceiver>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSArray *topRatedMovies;


@end

