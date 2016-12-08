#import "TVShow.h"
#import "Genre.h"
#import "GenreDb.h"

static NSString * const YearDateFormat=@"yyyy";

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
             @"origin_country":@"originCountries",
             @"rating":@"rating"};
}
+(NSDictionary *)propertiesMappingForDetails{
    return @{
             @"id":@"id",
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
             @"origin_country":@"originCountries",
             @"rating":@"rating",
             @"number_of_seasons":@"numberOfSeasons",
             @"number_of_episodes":@"numberOfEpisodes",
             @"episode_run_time":@"runtime"             
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
    /*
    [[RLMRealm defaultRealm] beginWriteTransaction];
    for(Genre *genre in genresArray){
        GenreDb *genreDb=[[GenreDb alloc] init];
        genreDb.id=genre.genreID;
        genreDb.genreName=genre.genreName;
        genreDb.isMovieGenre=NO;
        [[RLMRealm defaultRealm] addObject:genreDb];
    }
    [[RLMRealm defaultRealm] commitWriteTransaction];
    */
    
    genres=genresArray;
}

+(NSString *)getClassName{
    return @"TVShow";
}

-(NSString *)getFormattedReleaseDate{
    NSString *dateString=@"Tv Series ";
    if(self.releaseDate){
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
        NSString *dateString;
        [dateFormatter setDateFormat:YearDateFormat];
        dateString=[[[[dateString stringByAppendingString:@"("] stringByAppendingString:[dateFormatter stringFromDate:self.releaseDate]] stringByAppendingString:@" -"] stringByAppendingString:@")"];
    }
    
    return dateString;
    
}

+(TVShow *)tvShowWithSearchResultItem:(SearchResultItem *)searchResultItem{
    TVShow *newTvShow=[[TVShow alloc]init];
    
    newTvShow.id=searchResultItem.id;
    newTvShow.title=searchResultItem.name;
    newTvShow.originalTitle=searchResultItem.originalName;
    newTvShow.voteAverage=searchResultItem.voteAverage;
    newTvShow.voteCount=searchResultItem.voteCount;
    newTvShow.overview=searchResultItem.overview;
    newTvShow.releaseDate=searchResultItem.firstAirDate;
    newTvShow.posterPath=searchResultItem.posterPath;
    newTvShow.backdropPath=searchResultItem.backdropPath;

    
    return newTvShow;
}

+(NSArray *)getCriteriaForSorting{
    return @[@"Most popular",@"Latest",@"Highest-rated",@"Airing today",@"On the air"];
    
}

+(instancetype)tvShowWithTVShowDb:(TVShowDb *)tvShowDb{
    TVShow *newTvShow=[[TVShow alloc]init];
    
    newTvShow.id=tvShowDb.id;
    newTvShow.title=tvShowDb.title;
    newTvShow.originalTitle=tvShowDb.originalTitle;
    NSMutableArray *genres=[[NSMutableArray alloc]init];
    for(GenreDb *genreDb in tvShowDb.genres){
        [genres addObject:[NSNumber numberWithInteger:genreDb.id]];
    }
    newTvShow.genreIDs=genres;
    newTvShow.voteAverage=tvShowDb.voteAverage;
    newTvShow.voteCount=tvShowDb.voteCount;
    newTvShow.overview=tvShowDb.overview;
    newTvShow.releaseDate=tvShowDb.releaseDate;
    newTvShow.posterPath=tvShowDb.posterPath;
    newTvShow.backdropPath=tvShowDb.backdropPath;
    newTvShow.rating=tvShowDb.usersRating;
    newTvShow.duration=tvShowDb.duration;
    newTvShow.isInRatings=tvShowDb.isInRatings;
    newTvShow.isInFavorites=tvShowDb.isInFavorites;
    newTvShow.isInWatchlist=tvShowDb.isInWatchlist;
    
    return newTvShow;
}
+(NSArray *)tvShowsArrayFromRLMArray:(RLMResults *)results{
    NSMutableArray *tvShows=[[NSMutableArray alloc] init];
    for(TVShowDb *tvShowDb in results){
        [tvShows addObject:[TVShow tvShowWithTVShowDb:tvShowDb]];
    }
    return tvShows;
}

@end
