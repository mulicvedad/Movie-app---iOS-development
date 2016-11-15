#import "MovieDetails.h"

@implementation MovieDetails

+(NSDictionary *)propertiesMapping{
    return @{@"id":@"id",
             @"runtime":@"duration",
             @"homepage":@"homepage",
             @"backdrop_path":@"backdropPath",
             @"title":@"title",
             @"poster_path":@"posterPath",
             @"overview":@"overview",
             @"release_date":@"releaseDate",
             @"vote_average":@"voteAverage"
             };
}

@end
