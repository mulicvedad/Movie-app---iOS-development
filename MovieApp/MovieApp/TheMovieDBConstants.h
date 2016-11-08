#import <Foundation/Foundation.h>


@interface TheMovieDBConstants : NSObject
typedef enum Criteria
{
    MOST_POPULAR=0,
    LATEST=1,
    TOP_RATED=2,
    AIRING_TODAY=3,
    ON_THE_AIR=4
    
}Criterion;

typedef enum{
    MovieType,
    TVShowType
}MediaType;

typedef enum {
    GET,
    POST
}HTTPMethod;

typedef enum {
    AddedSucessfullyPostResponseStatusCode=1,
    RemovedSucessfullyPostResponseStatusCode=13
}PostResponseStatusCode;

extern NSString * const APIKeyParameterName;
extern NSString * const SortByParameterName;
extern NSString * const QueryParameterName;
extern NSString * const AppendToResponseParameterName;
extern NSString * const PageQueryParameterName;
extern NSString * const CriterionDictionaryKey;
extern NSString * const TypeDictionaryKey;
extern NSString * const ErrorDictionaryKey;
extern NSString *SideMenuOptionDictionaryKey;
extern NSString *UsernameParameterName;
extern NSString *PasswordParameterName;
extern NSString *RequestTokenParameterName;
extern NSString *ValueParameterName;
extern NSString *SessionIDParameterName;


extern NSString * const MovieDetailsSubpath;
extern NSString * const TVShowDetailsSubpath;
extern NSString * const MovieDiscoverSubpath;
extern NSString * const TVShowDiscoverSubpath;
extern NSString * const MovieLatestSubpath;
extern NSString * const TVShowLatestSubpath;
extern NSString * const MovieGenresSubpath;
extern NSString * const TVShowGenresSubpath;
extern NSString * const VideosSubpath;
extern NSString * const SeasonSubpath;
extern NSString * const SearchMultiSubpath;
extern NSString * const AppendedImagesSubpath;
extern NSString * const VideosForEpisodeSubpath;
extern NSString * const VideosForMovieSubpath;
extern NSString * const EpisodeDetailsSubpath;
extern NSString * const VariableSubpath;
extern NSString * const PersonDetailsSubpath;
extern NSString *CreateNewTokenSubpath;
extern NSString *ValidateTokenSubpath;
extern NSString *CreateNewSessionSubpath;
extern NSString *AccountDetailsSubpath;
extern NSString *FavoriteSubpath;
extern NSString *WatchlistSubpath;
extern NSString *RatedSubpath;
extern NSString *FavoriteMovieFullSubpath;
extern NSString *FavoriteTVShowFullSubpath;
extern NSString *WatchlistMovieFullSubpath;
extern NSString *WatchlistTVShowFullSubpath;
extern NSString *RatedMoviesFullSubpath;
extern NSString *RatedTVShowsFullSubpath;

extern NSString * const ResultsPath;

extern NSString * const GenresKeypath;
extern NSString * const CrewKeypath;
extern NSString * const CastKeypath;
extern NSString * const SeasonsKeypath;
extern NSString * const CreditsKeypath;
extern NSString * const ImageKeypath;
extern NSString * const ReviewKeypath;
extern NSString * const VideosKeypath;
extern NSString * const SeasonKeypath;
extern NSString * const EpisodesKeypath;
extern NSString * const CastCreditsKeypath;

extern NSString * const DetailsDictionaryValue;
extern NSString * const CreditsDictionaryValue;
extern NSString * const CriterionPopularityValue;
extern NSString * const CriterionReleaseDateValue;
extern NSString * const AppendImagesParameterValue;
extern NSString * const AppendCreditsParameterValue;
extern NSString * const AppendMovieCreditsParameterValue;
extern NSString * const AppendCombinedCreditsParameterValue;


extern NSString * const EmptyString;

extern NSString * const BaseImageUrlForWidth500;
extern NSString * const BaseImageUrlForWidth185;
extern NSString * const BaseImageUrlForWidth92;

extern NSString *MovieMediaType;
extern NSString *TVMediaType;

extern NSString *DataStorageReadyNotificationName;

+(NSString *)getTheMovieDbAPIKey;
+(NSString *)getTheMovieDbAPIBaseURLPath;
@end
