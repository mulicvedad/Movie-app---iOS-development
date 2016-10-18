#import <Foundation/Foundation.h>

@protocol CustomCellIdentityProtocol <NSObject>

+(NSString *)cellIdentifier;
+(NSString *)cellClassName;

@end
