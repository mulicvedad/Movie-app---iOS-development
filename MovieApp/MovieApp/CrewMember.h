#import <Foundation/Foundation.h>
#import "Person.h"

@interface CrewMember : Person

@property (nonatomic, strong) NSString *department;
@property (nonatomic, strong) NSString *job;
@property (nonatomic, strong) NSString *creditID;

+(NSDictionary *)propertiesMapping;
+(NSString *)getWritersFromArray:(NSArray *)crew;
+(NSString *)getDirectorsNameFromArray:(NSArray *)crew;
@end
