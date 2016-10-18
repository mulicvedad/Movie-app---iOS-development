#import "TVShowEpisode.h"

#define DATE_FORMAT @"dd MMMM yyyy"

@implementation TVShowEpisode

+(NSDictionary *)propertiesMapping{
    return @{@"id":@"id",
             @"air_date":@"airDate",
             @"name":@"name",
             @"overview":@"overview",
             @"episode_number":@"episodeNumber",
             @"vote_average":@"voteAverage",
             @"season_number":@"seasonNumber"
             };
}

-(NSString *)getFormattedAirDate{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    NSString *dateString=@"";
    if(self.airDate){
        [dateFormatter setDateFormat:DATE_FORMAT];
        dateString=[dateFormatter stringFromDate:self.airDate];
    }
    return dateString;
}
@end
