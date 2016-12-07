#import "CastMember.h"
static NSString * const DefaultDateFormat=@"dd MMMM yyyy";

@implementation CastMember

+(NSDictionary *)propertiesMapping{
    return @{
             @"cast_id":@"castID",
             @"character":@"character",
             @"credit_id":@"creditID",
             @"id":@"id",
             @"name":@"name",
             @"order":@"order",
             @"profile_path":@"profileImageUrl"
             
             };
}

+(NSString *)getCastStringRepresentationFromArray:(NSArray *)cast;{
    NSMutableString *castRepresentation=[NSMutableString stringWithString:@""];
    for(int i=0;i<[cast count];i++){
        CastMember *currentCastMember=(CastMember *)cast[i];
   
        if(i==3 || i==[cast count]-1){
            [castRepresentation appendString:currentCastMember.name];
            break;
        }
        else{
            [castRepresentation appendString:currentCastMember.name];
            [castRepresentation appendString:@", "];
        }
    }
    
    return castRepresentation;
}


+(CastMember *)castMemberWithCastMemberDb:(CastMemberDb *)castMemberDb{
    CastMember *newCastMember=[[CastMember alloc]init];
    
    newCastMember.id=castMemberDb.id;
    newCastMember.profileImageUrl=castMemberDb.profileImageUrl;
    newCastMember.castID=castMemberDb.castID;
    newCastMember.creditID=castMemberDb.creditID;
    newCastMember.character=castMemberDb.character;
    newCastMember.order=castMemberDb.order;
    newCastMember.name=castMemberDb.name;
    
    return newCastMember;
}
+(NSArray *)castMembersArrayWithRLMArray:(RLMResults *)results{
    NSMutableArray *newMembers=[[NSMutableArray alloc]  init];
    for(CastMemberDb *castMemberDb in results){
        [newMembers addObject:[CastMember castMemberWithCastMemberDb:castMemberDb]];
    }
    return newMembers;
}
@end
