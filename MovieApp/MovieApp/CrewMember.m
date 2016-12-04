
#import "CrewMember.h"

@implementation CrewMember

+(NSDictionary *)propertiesMapping{
    return @{@"credit_id":@"creditID",
             @"department":@"department",
             @"id":@"id",
             @"job":@"job",
             @"name":@"name",
             @"profile_path":@"profileImageUrl"
             };
}

+(NSString *)getWritersFromArray:(NSArray *)crew{
    NSMutableString *writers=[NSMutableString stringWithString:@""];
    int counter=0;
    for(CrewMember *currentCrewMember in crew){
        if([currentCrewMember.department isEqualToString:@"Writing"])
        {
            if(counter==3 || counter==[crew count]-1){
                [writers appendString:currentCrewMember.name];
                break;
            }
            else{
                [writers appendString:currentCrewMember.name];
                [writers appendString:@", "];
            }
        }
        counter++;
    }
    
    return writers;
}

+(NSString *)getDirectorsNameFromArray:(NSArray *)crew{
    for(CrewMember *currentCrewMember in crew){
        if([currentCrewMember.job isEqualToString:@"Director"])
        {
            return currentCrewMember.name;
        }
    }
    return @"";
}

+(CrewMember *)crewMemberWithCrewMemberDb:(CrewMemberDb *)crewMemberDb{
    CrewMember *newCrewMember=[[CrewMember alloc] init];
    
    newCrewMember.id=crewMemberDb.id;
    newCrewMember.name=crewMemberDb.name;
    newCrewMember.profileImageUrl=crewMemberDb.profileImageUrl;
    newCrewMember.department=crewMemberDb.department;
    newCrewMember.job=crewMemberDb.job;
    newCrewMember.creditID=crewMemberDb.creditID;
    
    return newCrewMember;
}

+(NSArray *)crewMembersArrayWithRLMArray:(RLMResults *)results{
    NSMutableArray *newCrew=[[NSMutableArray alloc] init];
    for(CrewMemberDb *crewMemberDb in results){
        [newCrew addObject:[CrewMember crewMemberWithCrewMemberDb:crewMemberDb]];
    }
    return newCrew;
}


@end
