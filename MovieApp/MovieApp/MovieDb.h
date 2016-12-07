#import <Realm/Realm.h>
#import "TVEventDb.h"
#import "ReviewDb.h"
@class Movie;

@interface MovieDb : TVEventDb

@property RLMArray<ReviewDb *><ReviewDb> *reviews;
-(id)initWithMovie:(Movie *)movie;

@end
