#import "MovieDb.h"
#import "Movie.h"
@implementation MovieDb

+(NSString *)primaryKey{
    return @"id";
}

-(instancetype)initWithMovie:(Movie *)movie{
    self = [super init];
    self.id=movie.id;
    self.title=movie.title;
    self.originalTitle=movie.originalTitle;
    self.posterPath=movie.posterPath;
    self.backdropPath=movie.backdropPath;
    self.overview=movie.overview;
    self.releaseDate=movie.releaseDate;
    self.originalLanguage=movie.originalLanguage;
    self.isInFavorites=movie.isInFavorites;
    self.isInWatchlist=movie.isInWatchlist;
    self.isInRatings=movie.isInRatings;
    self.voteCount=movie.voteCount;
    self.voteAverage=movie.voteAverage;
    
    return self;
}

@end
