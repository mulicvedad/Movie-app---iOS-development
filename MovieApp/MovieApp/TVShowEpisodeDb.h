#import <Realm/Realm.h>
#import "CastMemberDb.h"

@class TVShowEpisode;

@interface TVShowEpisodeDb : RLMObject

@property NSInteger id;
@property NSDate *airDate;
@property NSString *name;
@property NSString *overview;
@property NSInteger episodeNumber;
@property NSInteger seasonNumber;
@property float voteAverage;
@property RLMArray<CastMemberDb *><CastMemberDb> *cast;
+(TVShowEpisodeDb *)episodeDbWithEpisode:(TVShowEpisode *)episode;

@end

RLM_ARRAY_TYPE(TVShowEpisodeDb)
