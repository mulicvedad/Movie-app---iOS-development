#import <Realm/Realm.h>
#import "TVShowEpisodeDb.h"

@interface TVShowSeasonDb : RLMObject

@property NSInteger id;
@property NSDate *airDate;
@property NSInteger episodeCount;
@property NSString *posterPath;
@property NSInteger seasonNumber;
@property RLMArray<TVShowEpisodeDb *><TVShowEpisodeDb> *episodes;

@end
