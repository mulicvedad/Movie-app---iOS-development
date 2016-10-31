#import "TVShowCredit.h"

@implementation TVShowCredit
+(NSDictionary *)propertiesMapping{
    return @{@"id":@"id",
             @"credit_id":@"creditID",
             @"character":@"character",
             @"name":@"name",
             @"original_name":@"originalName",
             @"first_air_date":@"releaseDate",
             @"poster_path":@"posterPath",
             @"media_type":@"mediaType",
             @"episode_count":@"episodeCount"
             };
}

@end
