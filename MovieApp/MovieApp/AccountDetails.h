#import <Foundation/Foundation.h>
#import "AccountDetailsDb.h"

@interface AccountDetails : NSObject
@property (nonatomic) NSUInteger id;
@property (nonatomic,strong) NSString *name;
@property (nonatomic, strong) NSString *username;

+(NSDictionary *)propertiesMapping;
+(AccountDetails *)accountDetailsWithAccountDetailsDb:(AccountDetailsDb *)accountDetailsDb;

@end
