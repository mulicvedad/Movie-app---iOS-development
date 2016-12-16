#import "Movie.h"
#import "Genre.h"
#import "GenreDb.h"
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

+(NSDictionary *)propertiesMappingForDetails{
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
             @"rating":@"rating",
             @"runtime":@"duration"
             
             };
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
    
    RLMResults *genresDb=[GenreDb objectsWhere:@"isMovieGenre=YES"];
    
    if(genresDb.count==0){
        [[RLMRealm defaultRealm] beginWriteTransaction];
        for(Genre *genre in genresArray){
            GenreDb *genreDb=[[GenreDb alloc] init];
            genreDb.id=genre.genreID;
            genreDb.genreName=genre.genreName;
            genreDb.isMovieGenre=YES;
            [[RLMRealm defaultRealm] addObject:genreDb];
            
        }
        [[RLMRealm defaultRealm] commitWriteTransaction];
    }
    
     
    
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

+(instancetype)movieWithMovieDb:(MovieDb *)movieDb{
    Movie *movie=[[Movie alloc] init];
    movie.id=movieDb.id;
    movie.title=movieDb.title;
    movie.originalTitle=movieDb.originalTitle;
    movie.overview=movieDb.overview;
    NSMutableArray *genres=[[NSMutableArray alloc]init];
    for(GenreDb *genreDb in movieDb.genres){
        [genres addObject:[NSNumber numberWithInteger:genreDb.id]];
    }
    movie.genreIDs=genres;
    movie.releaseDate = movieDb.releaseDate;
    movie.posterPath=movieDb.posterPath;
    movie.backdropPath=movieDb.backdropPath;
    movie.rating=movieDb.usersRating;
    movie.voteCount=movieDb.voteCount;
    movie.voteAverage=movieDb.voteAverage;
    movie.duration=movieDb.duration;
    movie.isInRatings=movieDb.isInRatings;
    movie.isInFavorites=movieDb.isInFavorites;
    movie.isInWatchlist=movieDb.isInWatchlist;
    
    return movie;
    
}
+(NSArray *)moviesArrayFromRLMArray:(RLMResults *)results{
    NSMutableArray *movies=[[NSMutableArray alloc] init];
    for(MovieDb *movieDb in results){
        [movies addObject:[Movie movieWithMovieDb:movieDb]];
    }
    return movies;
}

- (void)encodeWithCoder:(NSCoder *)encoder {

    [encoder encodeObject:[NSNumber numberWithUnsignedInteger:self.id] forKey:@"id"];
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:[NSNumber numberWithFloat:self.voteAverage] forKey:@"voteAverage"];
    [encoder encodeObject:self.posterPath forKey:@"posterPath"];
    [encoder encodeObject:self.overview forKey:@"overview"];


}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {

        NSNumber *numId=[decoder decodeObjectForKey:@"id"];
        NSNumber *numVoteAverage=[decoder decodeObjectForKey:@"voteAverage"];
        self.id = [numId unsignedIntegerValue];
        self.title = [decoder decodeObjectForKey:@"title"];
        self.posterPath = [decoder decodeObjectForKey:@"posterPath"];
        self.voteAverage=[numVoteAverage floatValue];
        self.overview=[decoder decodeObjectForKey:@"overview"];
    }
    return self;
}

@end
