#import <Realm/Realm.h>
#import "PersonDb.h"

@interface CrewMemberDb : PersonDb

@property PersonDb *person;
@property NSString *department;
@property NSString *job;
@property NSString *creditID;

@end

RLM_ARRAY_TYPE(CrewMemberDb)
