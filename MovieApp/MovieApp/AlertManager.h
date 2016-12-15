#import <Foundation/Foundation.h>

@interface AlertManager : NSObject

+(void)displaySimpleAlertWithTitle:(NSString *)title description:(NSString *)description displayingController:(UIViewController *)viewController shouldPopViewController:(BOOL)popViewController;
@end
