#import <Foundation/Foundation.h>
#import "TVEventDetails.h"

@interface MovieDetails : TVEventDetails
@property (nonatomic, strong) NSString *homepage;
@property (nonatomic, strong) NSString *backdropPath;
@property (nonatomic, strong) NSArray *genres;
@property (nonatomic, strong) NSString *title;

+(NSDictionary *)propertiesMapping;
@end
