#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MovieAppConfiguration : NSObject

+(NSURL *)getFeedsSourceUrlPath;
+(NSString *)getApiKey;
+(NSURL *)getApiBaseURL;
@end
