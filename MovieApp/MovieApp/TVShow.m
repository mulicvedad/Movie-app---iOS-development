#import "TVShow.h"

@implementation TVShow

+(NSDictionary *)propertiesMapping{
    return @{@"id":@"id",
             @"name":@"title",
             @"vote_average":@"voteAverage",
             @"overview":@"overview",
             @"first_air_date":@"releaseDate",
             @"vote_count":@"voteCount",
             @"poster_path":@"posterPath",
             @"genre_ids":@"genreIDs",
             @"original_language":@"originalLanguage"};
}

@end
