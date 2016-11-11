#import <Foundation/Foundation.h>
#import "LoginRequest.h"
#import "LoginResponse.h"
#import "RequestToken.h"
#import "SessionIDResponse.h"
#import "DataProviderService.h"
#import "LoginManagerDelagate.h"

@interface LoginManager : NSObject
@property (nonatomic, strong) LoginRequest *loginData;
@property (nonatomic, strong) NSString *dummy;
@property (nonatomic, strong) id<LoginManagerDelegate> delegate;

-(void)loginWithLoginRequest:(LoginRequest *)loginData delegate:(id<LoginManagerDelegate>)delegate;
@end
