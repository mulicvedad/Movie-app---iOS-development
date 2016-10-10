#import <Foundation/Foundation.h>
#import "Person.h"

@interface CastMember : Person
@property (nonatomic) NSUInteger castID;
@property (nonatomic, strong) NSString *creditID;
@property (nonatomic, strong) NSString *character;
@property (nonatomic) NSUInteger order;

+(NSDictionary *)propertiesMapping;
+(NSString *)getCastStringRepresentationFromArray:(NSArray *)cast;

@end
