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
    self.usersRating=movie.rating;
    
    return self;
}


-(instancetype)initWithTVEventDetails:(TVEventDetails *)tvEventDetails movieId:(NSInteger)movieId{
    self = [super init];
    self.id=movieId;
    self.title=tvEventDetails.title;
    self.duration=tvEventDetails.duration;
    self.originalTitle=tvEventDetails.title;
    self.posterPath=tvEventDetails.posterPath;
    self.backdropPath=tvEventDetails.backdropPath;
    self.overview=tvEventDetails.overview;
    self.releaseDate=tvEventDetails.releaseDate;
    self.voteAverage=tvEventDetails.voteAverage;
    
    return self;
}

@end
