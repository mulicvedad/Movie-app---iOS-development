#import <Realm/Realm.h>
#import "PersonDb.h"

@class CrewMember;

@interface CrewMemberDb : PersonDb

@property NSString *department;
@property NSString *job;
@property NSString *creditID;

+(CrewMemberDb *)crewMemberDbWithCrewMember:(CrewMember *)crewMember;
@end

RLM_ARRAY_TYPE(CrewMemberDb)
