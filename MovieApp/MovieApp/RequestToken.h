#import <Foundation/Foundation.h>

@interface RequestToken : NSObject
@property (nonatomic) BOOL success;
@property (nonatomic, strong) NSDate *expirationDate;
@property (nonatomic, strong) NSString *requestToken;

+(NSDictionary *)propertiesMapping;

@end
