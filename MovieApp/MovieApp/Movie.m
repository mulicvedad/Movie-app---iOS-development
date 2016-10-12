#import "Movie.h"
#import "DataProviderService.h"
#import "Genre.h"

#define MOVIE_DATE_FORMAT @"dd MMMM yyyy"


@implementation Movie
static NSArray *genres=nil;
+(NSDictionary *)propertiesMapping{
    return @{@"id":@"id",
             @"title":@"title",
             @"original_title":@"originalTitle",
             @"vote_average":@"voteAverage",
             @"overview":@"overview",
             @"release_date":@"releaseDate",
             @"vote_count":@"voteCount",
             @"poster_path":@"posterPath",
             @"video":@"hasVideo",
             @"genre_ids":@"genreIDs",
             @"original_language":@"originalLanguage",
             @"backdrop_path":@"backdropPath"};
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

-(NSString *)getFormattedReleaseDate{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    NSString *dateString;
    [dateFormatter setDateFormat:MOVIE_DATE_FORMAT];
    dateString=[dateFormatter stringFromDate:self.releaseDate];
    return dateString;
}






@end
