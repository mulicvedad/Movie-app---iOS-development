#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface LoginRequest : NSObject
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

-(id)initWithUsername:(NSString *)usrname password:(NSString *)passwrd;
@end
