#import "TheMovieDBConstants.h"

@implementation TheMovieDBConstants

NSString * const TheMovieDbAPIDictionaryKey=@"TheMovieDbAPIKey";
NSString * const TheMovieDbBaseUrlPathDictionaryKey=@"TheMovieDbBaseUrl";

NSString * const APIKeyParameterName=@"api_key";
NSString * const SortByParameterName=@"sort_by";
NSString * const QueryParameterName=@"query";
NSString * const AppendToResponseParameterName=@"append_to_response";
NSString * const PageQueryParameterName=@"page";
NSString * const CriterionDictionaryKey=@"criterion";
NSString * const TypeDictionaryKey=@"type";
NSString * const ErrorDictionaryKey=@"error";

NSString * const MovieDetailsSubpath=@"/3/movie";
NSString * const TVShowDetailsSubpath=@"/3/tv";
NSString * const MovieDiscoverSubpath=@"/3/discover/movie";
NSString * const TVShowDiscoverSubpath=@"/3/discover/movie";
NSString * const MovieLatestSubpath=@"/now_playing";
NSString * const TVShowLatestSubpath=@"/on_the_air";
NSString * const MovieGenresSubpath=@"3/genre/movie/list";
NSString * const TVShowGenresSubpath=@"3/genre/tv/list";
NSString * const VideosSubpath=@"/videos";
NSString * const SeasonSubpath=@"/season";
NSString * const SearchMultiSubpath=@"/3/search/multi";
NSString * const AppendedImagesSubpath=@"/3/:id/:id";
NSString * const VideosForEpisodeSubpath=@"/:id/season/:id/episode/:id/videos";
NSString * const VideosForMovieSubpath=@"/:id/videos";
NSString * const EpisodeDetailsSubpath=@"/:id/season/:id";
NSString * const VariableSubpath=@"/:id";
NSString * const PersonDetailsSubpath=@"/3/person";

NSString * const ResultsPath=@"results";

NSString * const GenresKeypath=@"genres";
NSString * const CrewKeypath=@"crew";
NSString * const CastKeypath=@"cast";
NSString * const SeasonsKeypath=@"seasons";
NSString * const CreditsKeypath=@"/credits";
NSString * const ImageKeypath=@"images.posters";
NSString * const ReviewKeypath=@"reviews.results";
NSString * const VideosKeypath=@"videos";
NSString * const SeasonKeypath=@"/:id";
NSString * const EpisodesKeypath=@"episodes";
NSString * const CastCreditsKeypath=@"combined_credits.cast";

NSString * const DetailsDictionaryValue=@"details";
NSString * const CreditsDictionaryValue=@"credits";
NSString * const CriterionPopularityValue=@"popularity.desc";
NSString * const CriterionReleaseDateValue=@"release_date.desc";
NSString * const AppendImagesParameterValue=@"images,reviews";
NSString * const AppendCreditsParameterValue=@"credits";
NSString * const AppendMovieCreditsParameterValue=@"movie_credits";
NSString * const AppendCombinedCreditsParameterValue=@"combined_credits";

NSString * const EmptyString=@"";

NSString * const BaseImageUrlForWidth500=@"http://image.tmdb.org/t/p/w500";
NSString * const BaseImageUrlForWidth185=@"http://image.tmdb.org/t/p/w185";
NSString * const BaseImageUrlForWidth92=@"http://image.tmdb.org/t/p/w92";


+(NSString *)getTheMovieDbAPIKey{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:TheMovieDbAPIDictionaryKey];
}

+(NSString *)getTheMovieDbAPIBaseURLPath{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:TheMovieDbBaseUrlPathDictionaryKey];
}

@end
