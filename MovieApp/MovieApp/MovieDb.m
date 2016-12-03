#import "MovieDb.h"
#import "Movie.h"
@implementation MovieDb

+(NSString *)primaryKey{
    return @"id";
}
/*
 @property NSInteger id;
 @property NSString *title;
 @property NSString *originalTitle;
 @property NSString *posterPath;
 @property NSString *backdropPath;
 @property NSString *overview;
 @property NSDate *releaseDate;
 @property NSString *originalLanguage;
 @property float voteAverage;
 @property NSInteger voteCount;
 @property BOOL isInFavorites;
 @property BOOL isInWatchlist;
 @property BOOL isInRatings;
 @property BOOL isInLatest;
 @property BOOL isInPopular;
 @property BOOL isInHighestRated;
 @property float usersRating;
 @property NSInteger duration;
 @property RLMArray<GenreDb *><GenreDb> *genres;
 @property RLMArray<CastMemberDb *><CastMemberDb> *castMembers;
 @property RLMArray<CrewMemberDb *><CrewMemberDb> *crewMembers;
 @property RLMArray<ImageDb *><ImageDb> *images;
 */
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
