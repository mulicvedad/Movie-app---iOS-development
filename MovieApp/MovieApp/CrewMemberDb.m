#import "CrewMemberDb.h"
#import "CrewMember.h"

@implementation CrewMemberDb

+(NSString *)primaryKey{
    return @"id";
}

+(CrewMemberDb *)crewMemberDbWithCrewMember:(CrewMember *)crewMember{
    CrewMemberDb *newCrewMemberDb=[[CrewMemberDb alloc] init];
    
    newCrewMemberDb.id=crewMember.id;
    newCrewMemberDb.name=crewMember.name;
    newCrewMemberDb.profileImageUrl=crewMember.profileImageUrl;
    newCrewMemberDb.department=crewMember.department;
    newCrewMemberDb.job=crewMember.job;
    newCrewMemberDb.creditID=crewMember.creditID;
    
    return newCrewMemberDb;
}

@end
