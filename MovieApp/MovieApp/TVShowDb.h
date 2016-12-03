#import <Realm/Realm.h>
#import "TVEventDb.h"

@class TVShow;

@interface TVShowDb : TVEventDb

@property TVEventDb *tvEvent;
@property BOOL isOnTheAir;
@property BOOL isAiringToday;

-(id)initWithTVShow:(TVShow *)tvShow;

@end
