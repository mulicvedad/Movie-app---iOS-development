#import <Foundation/Foundation.h>

@interface MovieAppConfiguration : NSObject

+(NSURL *)getFeedsSourceUrlPath;
+(NSString *)getApiKey;
+(NSString *)getMoviesCollectionViewCellNibName;
+(NSString *)getMoviesCollectionViewCellIdentifier;

@end
