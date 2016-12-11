#import <Realm/Realm.h>
#import "TVEventDb.h"
#import "ReviewDb.h"
#import "TVEventDetails.h"

@class Movie;

@interface MovieDb : TVEventDb

@property RLMArray<ReviewDb *><ReviewDb> *reviews;
-(id)initWithMovie:(Movie *)movie;
-(instancetype)initWithTVEventDetails:(TVEventDetails *)tvEventDetails movieId:(NSInteger)movieId;
@end
