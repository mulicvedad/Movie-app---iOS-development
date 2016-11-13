#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TheMovieDBConstants.h"

typedef enum{
    SideMenuOptionFavorites,
    SideMenuOptionWatchlist,
    SideMenuOptionRatings,
    SideMenuOptionSettings,
    SideMenuOptionLogin,
    SideMenuOptionLogout,
    SideMenuOptionNone
} SideMenuOption;
@interface MovieAppConfiguration : NSObject

extern NSString * const YouTubeSiteName;
extern NSString * const FilledStarCode;
extern NSString *KeyChainItemWrapperIdentifier;
extern NSString *SessionIDKeyChainKey;
extern NSString *UsernameKeyChainKey;

extern NSString *FontAwesomeFontName;

extern NSString *HeartFontAwesomeCode;
extern NSString *EmptyHeartFontAwesomeCode;
extern NSString *StarFontAwesomeCode;
extern NSString *EmptyStarFontAwesomeCode;
extern NSString *WatchlistFontAwesomeCode;
extern NSString *EmptyWatchlistFontAwesomeCode;

extern NSString *TVShowsNotificationsEnabledNSUserDefaultsKey;
extern NSString *MoviesNotificationsEnabledNSUserDefaultsKey;

+(NSURL *)getFeedsSourceUrlPath;
+(NSString *)getApiKey;
+(NSURL *)getApiBaseURL;
+(UIColor *)getPrefferedSectionHeadlineColor;

+(UIColor *)getPrefferedYellowColor;
+(UIColor *)getPrefferedGreyColor;
+(UIColor *)getPreferredDarkGreyColor;
+(UIColor *)getPrefferedLightGreyColor;
+(UIColor *)getResultsTableViewBackgroungColor;
+(UIFont *)getPreferredFontWithSize:(CGFloat)fontSize isBold:(BOOL)bold;
+(UIColor *)getPrefferedYellowColorWithOpacity:(CGFloat)opacity;
+(UIColor *)getGradientStartPointColor;
+(UIColor *)getGradientMiddlePointColor;
+(UIColor *)getGradientEndPointColor;
+(UIColor *)getPreferredTextColorForSearchBar;
+(NSArray *)getCriteriaForLikedTVEventsSorting;
+(NSString *)getStringRepresentationOfSideMenuOption:(SideMenuOption) option;
@end
