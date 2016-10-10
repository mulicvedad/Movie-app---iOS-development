#import "TvShowSeason.h"

@implementation TvShowSeason


+(NSDictionary *)propertiesMapping{
    return @{@"air_date":@"airDate",
             @"episode_count":@"episodeCount",
             @"id":@"id",
             @"poster_path":@"posterPath",
             @"season_number":@"seasonNumber"
             };
}
@end
