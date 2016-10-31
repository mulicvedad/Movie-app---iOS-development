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



@end
