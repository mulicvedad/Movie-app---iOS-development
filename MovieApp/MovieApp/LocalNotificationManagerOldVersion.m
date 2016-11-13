#import "LocalNotificationManagerOldVersion.h"
#import "TVEvent.h"
#import "TVShowEpisode.h"

static LocalNotificationManagerOldVersion *sharedNotificationManager;
static CGFloat numberOfSecondsInOneDay=24.0f*60*60;
static CGFloat episodeNotificationTimeInterval=60.0f;

@implementation LocalNotificationManagerOldVersion

+(instancetype)sharedNotificationManager{
    if(!sharedNotificationManager){
        sharedNotificationManager=[[LocalNotificationManagerOldVersion alloc] init];
        
    }
    return sharedNotificationManager;
}

-(void)addNotificationAboutTVEvent:(TVEvent *)tvEvent{

    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    NSDate *today = [calendar dateFromComponents:components];
    components = [calendar components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:tvEvent.releaseDate];
    NSDate *airDate = [calendar dateFromComponents:components];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    NSString *dateString;
    NSDate *triggerDate;
    BOOL isToday;
    if([airDate compare:today]==NSOrderedAscending){
        //if airing date is older then today we dont need notification
        return;
    }
    else if([today isEqualToDate:airDate]) {
        [dateFormatter setDateFormat:@"HH:mm"];
        dateString=[@"Today: " stringByAppendingString:[dateFormatter stringFromDate:tvEvent.releaseDate]];
        //if episode air date is today we will get notification soon
        isToday=YES;
        triggerDate=[NSDate dateWithTimeIntervalSinceNow:episodeNotificationTimeInterval];
    }
    else{
        [dateFormatter setDateFormat:@"EEEE HH:mm"];
        dateString=[dateFormatter stringFromDate:tvEvent.releaseDate];
        
        //if episode air date is thursday we will get notification on wednesday
        triggerDate = [NSDate dateWithTimeInterval:-numberOfSecondsInOneDay sinceDate:tvEvent.releaseDate];
        
    }
    
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = triggerDate;
    localNotification.alertTitle=tvEvent.title;
    localNotification.alertBody=[@"Airing soon: " stringByAppendingString:dateString];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

-(void)addNotificationAboutEpisodes:(NSArray *)episodes{
    for(int i=0;i<[episodes count];i++){
        TVShowEpisode *episode=episodes[i];
        if(episode.airDate){
            TVEvent *episodeEvent=[[TVEvent alloc] init];
            episodeEvent.id=episode.id;
            episodeEvent.title=episode.name;
            episodeEvent.releaseDate=episode.airDate;
            [self addNotificationAboutTVEvent:episodeEvent];
        }
        
    }
}
@end
