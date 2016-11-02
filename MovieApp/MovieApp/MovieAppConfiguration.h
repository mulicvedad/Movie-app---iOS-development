#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TheMovieDBConstants.h"

typedef enum{
    SideMenuOptionFavorites,
    SideMenuOptionWatchlist,
    SideMenuOptionRatings,
    SideMenuOptionSettings,
    SideMenuOptionNone
} SideMenuOption;
@interface MovieAppConfiguration : NSObject

extern NSString * const YouTubeSiteName;
extern NSString * const FilledStarCode;

+(NSURL *)getFeedsSourceUrlPath;
+(NSString *)getApiKey;
+(NSURL *)getApiBaseURL;
+(UIColor *)getPrefferedSectionHeadlineColor;

+(UIColor *)getPrefferedYellowColor;
+(UIColor *)getPrefferedGreyColor;
+(UIColor *)getPrefferedLightGreyColor;
+(UIColor *)getResultsTableViewBackgroungColor;
+(UIFont *)getPreferredFontWithSize:(CGFloat)fontSize isBold:(BOOL)bold;
+(UIColor *)getPrefferedYellowColorWithOpacity:(CGFloat)opacity;
+(UIColor *)getGradientStartPointColor;
+(UIColor *)getGradientMiddlePointColor;
+(UIColor *)getGradientEndPointColor;
+(UIColor *)getPreferredTextColorForSearchBar;

@end
