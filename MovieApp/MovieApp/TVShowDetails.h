#import <Foundation/Foundation.h>
#import "TVEventDetails.h"
#import "TvShowSeason.h"

@interface TVShowDetails : TVEventDetails
@property(nonatomic) NSUInteger numberOfSeasons;
@property(nonatomic) NSUInteger numberOfEpisodes;
@property(nonatomic, strong) NSArray *seasons;

+(NSDictionary *)propertiesMapping;

@end
