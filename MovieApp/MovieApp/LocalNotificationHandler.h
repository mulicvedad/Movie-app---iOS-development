#import <Foundation/Foundation.h>
#import "TVEvent.h"

@protocol LocalNotificationHandler <NSObject>

+(instancetype)sharedNotificationManager;
-(void)addNotificationAboutTVEvent:(TVEvent *)tvEvent isEpisode:(BOOL)isEpisode;
-(void)addNotificationAboutEpisodes:(NSArray *)episodes;
-(void)removeAllNotificationsForMovies;
-(void)removeAllNotificationsForTVShows;
-(void)scheduleMoviesNotifications;
-(void)scheduleTVShowsNotifications;
-(void)scheduleTestNotifications;

@end
