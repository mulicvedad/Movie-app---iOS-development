#import <Foundation/Foundation.h>

@interface Genre : NSObject
@property (nonatomic) NSUInteger genreID;
@property (nonatomic,strong) NSString *genreName;

+(NSDictionary *)propertiesMapping;

@end
