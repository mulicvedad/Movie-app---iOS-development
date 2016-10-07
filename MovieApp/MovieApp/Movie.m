#import "Movie.h"
#import "DataProviderService.h"
#import "Genre.h"

@implementation Movie
static NSArray *genres=nil;
+(NSDictionary *)propertiesMapping{
    return @{@"id":@"id",
             @"title":@"title",
             @"vote_average":@"voteAverage",
             @"overview":@"overview",
             @"release_date":@"releaseDate",
             @"vote_count":@"voteCount",
             @"poster_path":@"posterPath",
             @"video":@"hasVideo",
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
    return @"Movie";
}


@end
