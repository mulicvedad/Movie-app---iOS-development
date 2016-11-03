#import "LoginRequest.h"

@implementation LoginRequest
-(void)initWithUsername:(NSString *)usrname password:(NSString *)passwrd{
    self.username=usrname;
    self.password=passwrd;
}

@end
