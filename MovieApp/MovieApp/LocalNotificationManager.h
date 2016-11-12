#import <Foundation/Foundation.h>
#import "TVEvent.h"
#import <UserNotifications/UserNotifications.h>

@interface LocalNotificationManager : NSObject <UNUserNotificationCenterDelegate>

-(void)configure;
-(void)addNotificationAboutTVEvent:(TVEvent *)tvEvent;
-(void)addNotificationAboutEpisodes:(NSArray *)episodes;
+(instancetype)sharedNotificationManager;
@end
