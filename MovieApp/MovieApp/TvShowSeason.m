#import "TvShowSeason.h"

#define DATE_FORMAT @"yyyy"

@implementation TvShowSeason


+(NSDictionary *)propertiesMapping{
    return @{@"air_date":@"airDate",
             @"episode_count":@"episodeCount",
             @"id":@"id",
             @"poster_path":@"posterPath",
             @"season_number":@"seasonNumber"
             };
}

+(NSString *)getStringOfYearsForSeasons:(NSArray *)seasons{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    NSString *dateString;
    [dateFormatter setDateFormat:DATE_FORMAT];
    
    NSMutableString *yearsAsString=[NSMutableString stringWithString:@""];
    
    for(int i=(int)[seasons count]-1;i>=0;i--){
        NSDate *currentDate=((TvShowSeason *)seasons[i]).airDate;
        if(currentDate){
            dateString=[dateFormatter stringFromDate:currentDate];
            [yearsAsString appendFormat:@"%@ ",dateString];
        }
        
    }
    return yearsAsString;
}
@end
