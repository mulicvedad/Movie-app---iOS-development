#import <Foundation/Foundation.h>


@interface TheMovieDBConstants : NSObject


extern NSString * const APIKeyParameterName;
extern NSString * const SortByParameterName;
extern NSString * const QueryParameterName;
extern NSString * const AppendToResponseParameterName;
extern NSString * const PageQueryParameterName;
extern NSString * const CriterionDictionaryKey;
extern NSString * const TypeDictionaryKey;
extern NSString * const ErrorDictionaryKey;


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

extern NSString * const DetailsDictionaryValue;
extern NSString * const CreditsDictionaryValue;
extern NSString * const CriterionPopularityValue;
extern NSString * const CriterionReleaseDateValue;
extern NSString * const AppendImagesParameterValue;
extern NSString * const AppendCreditsParameterValue;

extern NSString * const EmptyString;

extern NSString * const BaseImageUrlForWidth500;
extern NSString * const BaseImageUrlForWidth185;
extern NSString * const BaseImageUrlForWidth92;


typedef enum Criteria
{
    MOST_POPULAR=0,
    LATEST=1,
    TOP_RATED=2,
    AIRING_TODAY=3,
    ON_THE_AIR=4
    
}Criterion;

+(NSString *)getTheMovieDbAPIKey;
+(NSString *)getTheMovieDbAPIBaseURLPath;
@end
