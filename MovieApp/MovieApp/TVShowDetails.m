#import "TVShowDetails.h"

@implementation TVShowDetails

+(NSDictionary *)propertiesMapping{
    return @{@"id":@"id",
             @"duration":@"duration",
             @"number_of_seasons":@"numberOfSeasons",
             @"number_of_episodes":@"numberOfEpisodes",
             @"seasons":@"seasons"
             };
}

@end
