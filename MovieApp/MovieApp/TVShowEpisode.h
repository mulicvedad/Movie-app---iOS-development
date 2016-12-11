#import <Foundation/Foundation.h>
#import "TVShowEpisodeDb.h"

@interface TVShowEpisode : NSObject

@property (nonatomic) NSUInteger id;
@property (nonatomic, strong) NSDate *airDate;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *overview;
@property (nonatomic) NSUInteger episodeNumber;
@property (nonatomic) NSUInteger seasonNumber;
@property (nonatomic) float voteAverage;

+(NSDictionary *)propertiesMapping;

-(NSString *)getFormattedAirDate;

+(TVShowEpisode *)episodeWithEpisodeDb:(TVShowEpisodeDb *)episodeDb;
+(NSArray *)episodesArrayWithRLMArray:(RLMResults *)results;
@end
