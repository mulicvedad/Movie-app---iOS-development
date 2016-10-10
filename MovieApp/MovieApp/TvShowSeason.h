#import <Foundation/Foundation.h>

@interface TvShowSeason : NSObject
@property (nonatomic, strong) NSDate *airDate;
@property (nonatomic) NSUInteger episodeCount;
@property (nonatomic) NSUInteger id;
@property (nonatomic, strong) NSString *posterPath;
@property (nonatomic) NSUInteger seasonNumber;

+(NSDictionary *)propertiesMapping;
@end
