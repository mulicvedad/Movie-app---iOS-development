#import "TVShowDetails.h"

@implementation TVShowDetails

+(NSDictionary *)propertiesMapping{
    return @{@"id":@"id",
             @"number_of_seasons":@"numberOfSeasons",
             @"number_of_episodes":@"numberOfEpisodes",
             @"backdrop_path":@"backdropPath",
             @"name":@"title",
             @"poster_path":@"posterPath",
             @"overview":@"overview",
             @"first_air_date":@"releaseDate",
             @"vote_average":@"voteAverage"
             };
}

@end
