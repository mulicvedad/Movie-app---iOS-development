#import <Foundation/Foundation.h>

@interface LoginResponse : NSObject
@property (nonatomic) BOOL success;
@property (nonatomic, strong) NSString *requestToken;

+(NSDictionary *)propertiesMapping;

@end
