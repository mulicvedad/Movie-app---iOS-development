#import <Realm/Realm.h>
#import "PersonDb.h"

@class CastMember;

@interface CastMemberDb : PersonDb

@property NSInteger castID;
@property NSString *creditID;
@property NSString *character;
@property NSInteger order;

+(CastMember *)castMemberDbWithCastMember:(CastMember *)castMember;

@end

RLM_ARRAY_TYPE(CastMemberDb)
