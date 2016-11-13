#import <Foundation/Foundation.h>
#import "TVEvent.h"

@protocol LocalNotificationHandler <NSObject>

+(instancetype)sharedNotificationManager;
-(void)addNotificationAboutTVEvent:(TVEvent *)tvEvent;
-(void)addNotificationAboutEpisodes:(NSArray *)episodes;


@end
