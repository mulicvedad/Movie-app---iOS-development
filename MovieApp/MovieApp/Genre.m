#import "Genre.h"

@implementation Genre

+(NSDictionary *)propertiesMapping{
    return @{@"id" : @"genreID",
             @"name" : @"genreName"};
}
@end
