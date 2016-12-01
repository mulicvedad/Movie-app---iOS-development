#import <Realm/Realm.h>
#import "TVEventDb.h"
#import "Movie.h"

@interface MovieDb : TVEventDb

@property TVEventDb *tvEvent;

-(instancetype)initWithMovie:(Movie *)movie;
@end
