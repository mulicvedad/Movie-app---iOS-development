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
+(UIFont *)getPreferredFontWithSize:(CGFloat)fontSize;

@end
