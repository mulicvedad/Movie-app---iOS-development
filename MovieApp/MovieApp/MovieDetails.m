#import "MovieDetails.h"

@implementation MovieDetails

+(NSDictionary *)propertiesMapping{
    return @{@"id":@"id",
             @"runtime":@"duration",
             @"homepage":@"homepage",
             @"backdrop_path":@"backdropPath",
             @"genres":@"genres"
             };
}

@end
