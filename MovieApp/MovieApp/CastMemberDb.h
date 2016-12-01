#import <Realm/Realm.h>
#import "PersonDb.h"

@interface CastMemberDb : PersonDb

@property NSInteger castID;
@property NSString *creditID;
@property NSString *character;
@property NSInteger order;
@property PersonDb *person;

@end

RLM_ARRAY_TYPE(CastMemberDb)
