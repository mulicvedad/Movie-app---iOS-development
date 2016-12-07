#import <Realm/Realm.h>
#import "TVEventDb.h"
#import "TVShowSeasonDb.h"

@class TVShow;

@interface TVShowDb : TVEventDb

@property BOOL isOnTheAir;
@property BOOL isAiringToday;
@property RLMArray<TVShowSeasonDb *><TVShowSeasonDb> *seasons;

-(id)initWithTVShow:(TVShow *)tvShow;

@end
