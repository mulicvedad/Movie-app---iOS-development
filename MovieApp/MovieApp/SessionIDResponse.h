#import <Foundation/Foundation.h>

@interface SessionIDResponse : NSObject
@property (nonatomic) NSUInteger id;
@property (nonatomic, strong) NSString * sessionID;

+(NSDictionary *)propertiesMapping;

@end
