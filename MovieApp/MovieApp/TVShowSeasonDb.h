#import <Realm/Realm.h>
#import "TVShowEpisodeDb.h"

@class TvShowSeason;

@interface TVShowSeasonDb : RLMObject

@property NSInteger id;
@property NSDate *airDate;
@property NSInteger episodeCount;
@property NSString *posterPath;
@property NSInteger seasonNumber;
@property RLMArray<TVShowEpisodeDb *><TVShowEpisodeDb> *episodes;

+(TVShowSeasonDb *)seasonDbWithSeason:(TvShowSeason *)season;

@end

RLM_ARRAY_TYPE(TVShowSeasonDb)
