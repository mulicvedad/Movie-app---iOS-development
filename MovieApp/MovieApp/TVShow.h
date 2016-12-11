#import <Foundation/Foundation.h>
#import "TVEvent.h"
#import "SearchResultItem.h"

@interface TVShow : TVEvent
@property(nonatomic) NSUInteger runtime;
@property (nonatomic) NSInteger numberOfSeasons;
@property (nonatomic) NSInteger numberOfEpisodes;
@property(nonatomic, strong) NSArray *originCountries;

+(NSDictionary *)propertiesMapping;
+(void)initializeGenres:(NSArray *)genresArray;
+(TVShow *)tvShowWithSearchResultItem:(SearchResultItem *)searchResultItem;
+(NSArray *)getCriteriaForSorting;

+(instancetype)tvShowWithTVShowDb:(TVShowDb *)tvShowDb;
+(NSArray *)tvShowsArrayFromRLMArray:(RLMResults *)results;

@end
