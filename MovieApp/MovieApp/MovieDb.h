#import <Realm/Realm.h>
#import "TVEventDb.h"

@class Movie;

@interface MovieDb : TVEventDb

@property TVEventDb *tvEvent;

-(id)initWithMovie:(Movie *)movie;
@end
