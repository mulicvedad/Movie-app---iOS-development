#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TVEvent.h"
#import "SearchResultItem.h"
#import "TVEventCredit.h"
@interface Movie : TVEvent

@property (nonatomic) BOOL hasVideo;

+(NSDictionary *)propertiesMapping;
+(void)initializeGenres:(NSArray *)genresArray;
+(Movie *)movieWithSearchResultItem:(SearchResultItem *)searchResultItem;
+(NSArray *)getCriteriaForSorting;
@end
