#import <Realm/Realm.h>

@interface TVShowEpisodeDb : RLMObject

@property NSInteger id;
@property NSDate *airDate;
@property NSString *name;
@property NSString *overview;
@property NSInteger episodeNumber;
@property NSInteger seasonNumber;
@property float voteAverage;

@end

RLM_ARRAY_TYPE(TVShowEpisodeDb)
