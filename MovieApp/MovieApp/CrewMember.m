
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


@end
