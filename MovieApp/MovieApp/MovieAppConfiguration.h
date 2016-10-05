#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MovieAppConfiguration : NSObject

+(NSURL *)getFeedsSourceUrlPath;
+(NSString *)getApiKey;
+(NSString *)getMoviesCollectionViewCellNibName;
+(NSString *)getMoviesCollectionViewCellIdentifier;

@end
