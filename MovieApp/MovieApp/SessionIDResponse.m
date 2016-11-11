#import "SessionIDResponse.h"

@implementation SessionIDResponse
+(NSDictionary *)propertiesMapping{
    return @{@"id":@"id",
             @"session_id":@"sessionID"
             };
}
@end
