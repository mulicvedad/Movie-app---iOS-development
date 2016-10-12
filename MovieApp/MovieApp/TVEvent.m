#import "TVEvent.h"

@implementation TVEvent

//abstract method
+(NSDictionary *)propertiesMapping{
    return nil;
}

//abstract method
+(void)initializeGenres:(NSArray *)genres{
    
}

//abstract method
+(NSString *)getGenreNameForId:(NSUInteger)genreId{
    return nil;
}

+(NSString *)getClassName{
    return @"TVEvent";
}
@end
