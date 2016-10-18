#import "TVShowDetails.h"

#define DATE_KEY @"air_date"

@implementation TVShowDetails

+(NSDictionary *)propertiesMapping{
    return @{@"id":@"id",
             @"duration":@"episode_run_time",
             @"number_of_seasons":@"numberOfSeasons",
             @"number_of_episodes":@"numberOfEpisodes"
             };
}


@end
