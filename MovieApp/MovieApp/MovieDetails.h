#import <Foundation/Foundation.h>
#import "TVEventDetails.h"

@interface MovieDetails : TVEventDetails
@property (nonatomic, strong) NSString *homepage;
@property (nonatomic, strong) NSArray *genres;

+(NSDictionary *)propertiesMapping;
@end
