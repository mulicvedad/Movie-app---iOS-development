#import "MovieCredit.h"

@implementation MovieCredit
+(NSDictionary *)propertiesMapping{
    return @{@"id":@"id",
             @"credit_id":@"creditID",
             @"character":@"character",
             @"title":@"title",
             @"original_title":@"originalTitle",
             @"original_name":@"originalName",
             @"release_date":@"releaseDate",
             @"poster_path":@"posterPath",
             @"media_type":@"mediaType"
             };
}

@end
