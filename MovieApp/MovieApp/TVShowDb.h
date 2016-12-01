#import <Realm/Realm.h>
#import "TVEventDb.h"

@interface TVShowDb : TVEventDb

@property TVEventDb *tvEvent;
@property BOOL isOnTheAir;
@property BOOL isAiringToday;

@end
