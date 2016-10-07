#import "TVShow.h"
#import "Genre.h"

@implementation TVShow
static NSArray *genres=nil;

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

-(NSString *)getGenreNameForId:(NSUInteger)genreId{
    for(Genre *genre in genres){
        if(genre.genreID==genreId){
            return genre.genreName;
        }
    }
    return @"";
}

+(void)initializeGenres:(NSArray *)genresArray{
    genres=genresArray;
}

+(NSString *)getClassName{
    return @"TVShow";
}

@end
