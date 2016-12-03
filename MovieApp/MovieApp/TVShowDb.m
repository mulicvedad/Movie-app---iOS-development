#import "TVShowDb.h"
#import "TVShow.h"

@implementation TVShowDb

+(NSString *)primaryKey{
    return @"id";
}

-(id)initWithTVShow:(TVShow *)tvShow{
    self = [super init];
    
    self.id=tvShow.id;
    self.title=tvShow.title;
    self.originalTitle=tvShow.originalTitle;
    self.posterPath=tvShow.posterPath;
    self.backdropPath=tvShow.backdropPath;
    self.overview=tvShow.overview;
    self.releaseDate=tvShow.releaseDate;
    self.originalLanguage=tvShow.originalLanguage;
    self.isInFavorites=tvShow.isInFavorites;
    self.isInWatchlist=tvShow.isInWatchlist;
    self.isInRatings=tvShow.isInRatings;
    self.voteCount=tvShow.voteCount;
    self.voteAverage=tvShow.voteAverage;
    
    return self;
}

@end
