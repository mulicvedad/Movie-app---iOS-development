#import "TVShow.h"
#import "Genre.h"

#define TVSHOW_DATE_FORMAT @"yyyy"

@implementation TVShow
static NSArray *genres=nil;

+(NSDictionary *)propertiesMapping{
    return @{@"id":@"id",
             @"name":@"title",
             @"original_name":@"originalTitle",
             @"vote_average":@"voteAverage",
             @"overview":@"overview",
             @"first_air_date":@"releaseDate",
             @"vote_count":@"voteCount",
             @"poster_path":@"posterPath",
             @"genre_ids":@"genreIDs",
             @"original_language":@"originalLanguage",
             @"backdrop_path":@"backdropPath",
             @"origin_country":@"originCountries",};
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

-(NSString *)getFormattedReleaseDate{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    NSString *dateString;
    [dateFormatter setDateFormat:TVSHOW_DATE_FORMAT];
    dateString=[[[[@"Tv Series " stringByAppendingString:@"("] stringByAppendingString:[dateFormatter stringFromDate:self.releaseDate]] stringByAppendingString:@" -"] stringByAppendingString:@")"];
    return dateString;
    
}


@end
