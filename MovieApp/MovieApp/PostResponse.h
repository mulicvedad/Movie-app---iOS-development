#import <Foundation/Foundation.h>

@interface PostResponse : NSObject
@property (nonatomic) NSUInteger statusCode;
@property (nonatomic, strong) NSString * statusMessage;

+(NSDictionary *)propertiesMapping;

@end
