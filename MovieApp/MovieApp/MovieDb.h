#import <Realm/Realm.h>
#import "TVEventDb.h"

@class Movie;

@interface MovieDb : TVEventDb

-(id)initWithMovie:(Movie *)movie;

@end
