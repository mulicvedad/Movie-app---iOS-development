#import "Movie.h"
#import "DataProviderService.h"
#import "Genre.h"

static NSString * const DefaultDateFormat=@"dd MMMM yyyy";

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
             @"backdrop_path":@"backdropPath",
             @"rating":@"rating"};
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
    NSString *dateString=@"";
    [dateFormatter setDateFormat:DefaultDateFormat];
    dateString=[dateFormatter stringFromDate:self.releaseDate];
    return dateString;
}

+(Movie *)movieWithSearchResultItem:(SearchResultItem *)searchResultItem{
    Movie *newMovie=[[Movie alloc]init];
    
    newMovie.id=searchResultItem.id;
    newMovie.title=searchResultItem.title;
    newMovie.originalTitle=searchResultItem.originalTitle;
    newMovie.voteAverage=searchResultItem.voteAverage;
    newMovie.voteCount=searchResultItem.voteCount;
    newMovie.overview=searchResultItem.overview;
    newMovie.releaseDate=searchResultItem.releaseDate;
    newMovie.posterPath=searchResultItem.posterPath;
    newMovie.backdropPath=searchResultItem.backdropPath;
    
    return newMovie;
}

+(NSArray *)getCriteriaForSorting{
    return @[@"Most popular",@"Latest",@"Highest-rated"];

}




@end
