#import <Foundation/Foundation.h>

@interface AccountDetails : NSObject
@property (nonatomic) NSUInteger id;
@property (nonatomic,strong) NSString *name;
@property (nonatomic, strong) NSString *username;

+(NSDictionary *)propertiesMapping;
@end
