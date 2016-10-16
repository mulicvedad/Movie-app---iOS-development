
#import "SearchResultItem.h"

@implementation SearchResultItem

+(NSDictionary *)propertiesMapping{
    return @{@"id":@"id",
             @"title":@"title",
             @"original_title":@"originalTitle",
             @"name":@"name",
             @"original_name":@"originalName",
             @"vote_average":@"voteAverage",
             @"overview":@"overview",
             @"release_date":@"releaseDate",
             @"first_air_date":@"firstAirDate",
             @"vote_count":@"voteCount",
             @"poster_path":@"posterPath",
             @"genre_ids":@"genreIDs",
             @"original_language":@"originalLanguage",
             @"backdrop_path":@"backdropPath",
             @"media_type":@"mediaType"
             };
}

@end
