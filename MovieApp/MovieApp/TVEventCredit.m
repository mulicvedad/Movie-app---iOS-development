#import "TVEventCredit.h"

@implementation TVEventCredit

+(NSDictionary *)propertiesMapping{
    return @{@"id":@"id",
             @"credit_id":@"creditID",
             @"character":@"character",
             @"name":@"name",
             @"title":@"title",
             @"poster_path":@"posterPath",
             @"media_type":@"mediaType",
             };
}



@end
