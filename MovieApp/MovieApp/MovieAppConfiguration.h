#import <Foundation/Foundation.h>

@interface MovieAppConfiguration : NSObject

+(NSURL *)getFeedsSourceUrlPath;
+(NSString *)getApiKey;
+(NSURL *)getApiBaseURL;
@end
