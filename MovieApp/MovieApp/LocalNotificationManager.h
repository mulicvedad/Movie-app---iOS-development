#import <Foundation/Foundation.h>
#import "TVEvent.h"
#import <UserNotifications/UserNotifications.h>
#import "LocalNotificationHandler.h"

@interface LocalNotificationManager : NSObject <UNUserNotificationCenterDelegate, LocalNotificationHandler>

@end
