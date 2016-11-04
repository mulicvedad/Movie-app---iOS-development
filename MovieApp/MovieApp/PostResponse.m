#import "PostResponse.h"

@implementation PostResponse
+(NSDictionary *)propertiesMapping{
    return @{@"status_code":@"statusCode",
             @"status_message":@"statusMessage"
             };
}
@end
