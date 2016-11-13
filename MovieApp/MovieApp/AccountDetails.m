#import "AccountDetails.h"

@implementation AccountDetails
+(NSDictionary *)propertiesMapping{
    return @{@"id":@"id",
             @"name":@"name",
             @"username":@"username"
             };
}
@end
