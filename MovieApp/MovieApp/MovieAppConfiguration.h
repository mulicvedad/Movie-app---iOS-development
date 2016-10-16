#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MovieAppConfiguration : NSObject

+(NSURL *)getFeedsSourceUrlPath;
+(NSString *)getApiKey;
+(NSURL *)getApiBaseURL;
+(UIColor *)getPrefferedSectionHeadlineColor;

+(UIColor *)getPrefferedYellowColor;
+(UIColor *)getPrefferedGreyColor;
+(UIColor *)getResultsTableViewBackgroungColor;
+(UIFont *)getPreferredFontWithSize:(CGFloat)fontSize isBold:(BOOL)bold;
+(UIColor *)getPrefferedYellowColorWithOpacity:(CGFloat)opacity;

@end
