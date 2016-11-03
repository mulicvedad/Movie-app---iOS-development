#import "RequestToken.h"

@implementation RequestToken

+(NSDictionary *)propertiesMapping{
    return @{@"success":@"success",
             @"expires_at":@"expirationDate",
             @"request_token":@"requestToken"
             };
}
@end
