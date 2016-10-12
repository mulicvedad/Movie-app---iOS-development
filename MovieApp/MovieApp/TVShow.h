#import <Foundation/Foundation.h>
#import "TVEvent.h"

@interface TVShow : TVEvent
@property(nonatomic) NSUInteger runtime;
@property(nonatomic, strong) NSArray *originCountries;

+(NSDictionary *)propertiesMapping;
+(void)initializeGenres:(NSArray *)genresArray;
@end
