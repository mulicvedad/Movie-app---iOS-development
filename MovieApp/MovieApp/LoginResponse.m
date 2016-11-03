#import "LoginResponse.h"

@implementation LoginResponse
+(NSDictionary *)propertiesMapping{
    return @{@"success":@"success",
             @"request_token":@"requestToken"
             };
}
@end
