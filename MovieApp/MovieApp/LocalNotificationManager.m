#import "LocalNotificationManager.h"
#import "TVShowEpisode.h"

static LocalNotificationManager *sharedNotificationManager;
static CGFloat numberOfSecondsInOneDay=24.0f*60*60;
static CGFloat episodeNotificationTimeInterval=60.0f;

@implementation LocalNotificationManager

+(instancetype)sharedNotificationManager{
    if(!sharedNotificationManager){
        sharedNotificationManager=[[LocalNotificationManager alloc] init];
        UNUserNotificationCenter *notificationCenter=[UNUserNotificationCenter currentNotificationCenter];
        notificationCenter.delegate=sharedNotificationManager;
    }
    return sharedNotificationManager;
}

-(void)configure{
    UNUserNotificationCenter *notificationCenter=[UNUserNotificationCenter currentNotificationCenter];
    UNAuthorizationOptions options = UNAuthorizationOptionAlert + UNAuthorizationOptionSound;
    
    [notificationCenter requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (!granted) {
            //user didnt allow
        }
    }];
}

-(void)addNotificationAboutTVEvent:(TVEvent *)tvEvent{
    NSCalendar *cal = [NSCalendar currentCalendar];

    NSDateComponents *components = [cal components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    NSDate *today = [cal dateFromComponents:components];
    components = [cal components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:tvEvent.releaseDate];
    NSDate *otherDate = [cal dateFromComponents:components];
    UNTimeIntervalNotificationTrigger *timeIntervalTrigger;
    UNCalendarNotificationTrigger *calendarTrigger;
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    NSString *dateString;
    BOOL isToday;
    if([otherDate compare:today]==NSOrderedAscending){
        //if airing date is older then today we dont need notification
        return;
    }
    else if([today isEqualToDate:otherDate]) {
        [dateFormatter setDateFormat:@"HH:mm"];
        dateString=[@"Today: " stringByAppendingString:[dateFormatter stringFromDate:tvEvent.releaseDate]];
        //if episode air date is today we will get notification soon
        timeIntervalTrigger=[UNTimeIntervalNotificationTrigger triggerWithTimeInterval:episodeNotificationTimeInterval repeats:NO];
        isToday=YES;
    }
    else{
        [dateFormatter setDateFormat:@"EEEE HH:mm"];
        dateString=[dateFormatter stringFromDate:tvEvent.releaseDate];
        
        //if episode air date is thursday we will get notification on wednesday
        NSDate *triggerDate = [NSDate dateWithTimeInterval:-numberOfSecondsInOneDay sinceDate:tvEvent.releaseDate];
        NSDateComponents *triggerDateComponents = [[NSCalendar currentCalendar]
                                         components:NSCalendarUnitYear +
                                         NSCalendarUnitMonth + NSCalendarUnitDay +
                                         NSCalendarUnitHour + NSCalendarUnitMinute +
                                         NSCalendarUnitSecond fromDate:triggerDate];
        calendarTrigger=[UNCalendarNotificationTrigger triggerWithDateMatchingComponents:triggerDateComponents repeats:NO];
    }
    
    
    NSString *notificationIdentifier=[NSString stringWithFormat:@"%d", (int)tvEvent.id];
    UNUserNotificationCenter *notificationCenter=[UNUserNotificationCenter currentNotificationCenter];
    UNMutableNotificationContent *notificationContent = [UNMutableNotificationContent new];
    
    notificationContent.title=tvEvent.title;
    notificationContent.body=[@"Airing soon: " stringByAppendingString:dateString];
    notificationContent.sound=[UNNotificationSound defaultSound];
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:notificationIdentifier
                                                                          content:notificationContent trigger:isToday ? timeIntervalTrigger: calendarTrigger];
    
    [notificationCenter addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error!=nil) {
            //an error ocured
        }
    }];

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


-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    
}

@end
