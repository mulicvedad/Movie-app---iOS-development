#import <Foundation/Foundation.h>
#import "Person.h"
#import "CrewMemberDb.h"

@interface CrewMember : Person

@property (nonatomic, strong) NSString *department;
@property (nonatomic, strong) NSString *job;
@property (nonatomic, strong) NSString *creditID;

+(NSDictionary *)propertiesMapping;
+(NSString *)getWritersFromArray:(NSArray *)crew;
+(NSString *)getDirectorsNameFromArray:(NSArray *)crew;

+(CrewMember *)crewMemberWithCrewMemberDb:(CrewMemberDb *)crewMemberDb;
+(NSArray *)crewMembersArrayWithRLMArray:(RLMResults *)results;
@end
