#import <Foundation/Foundation.h>
#import "TVShowSeasonDb.h"

@interface TvShowSeason : NSObject
@property (nonatomic, strong) NSDate *airDate;
@property (nonatomic) NSUInteger episodeCount;
@property (nonatomic) NSUInteger id;
@property (nonatomic, strong) NSString *posterPath;
@property (nonatomic) NSUInteger seasonNumber;

+(NSDictionary *)propertiesMapping;
+(NSString *)getStringOfYearsForSeasons:(NSArray *)seasons;
-(NSString *)getReleaseYear;

+(TvShowSeason *)seasonWithSeasonDb:(TVShowSeasonDb *)seasonDb;
+(NSArray *)seasonsArrayWithRLMArray:(RLMResults *)results;
@end
