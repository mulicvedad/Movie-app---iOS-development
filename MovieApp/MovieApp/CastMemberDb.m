#import "CastMemberDb.h"
#import "CastMember.h"

@implementation CastMemberDb

+(NSString *)primaryKey{
    return @"id";
}

+(CastMemberDb *)castMemberDbWithCastMember:(CastMember *)castMember{
    CastMemberDb *newCastMemberDb=[[CastMemberDb alloc] init];
    
    newCastMemberDb.id=castMember.id;
    newCastMemberDb.profileImageUrl=castMember.profileImageUrl;
    newCastMemberDb.castID=castMember.castID;
    newCastMemberDb.creditID=castMember.creditID;
    newCastMemberDb.character=castMember.character;
    newCastMemberDb.order=castMember.order;
    
    return newCastMemberDb;
}
@end
