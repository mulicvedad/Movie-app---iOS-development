#import "LoginRequest.h"

@implementation LoginRequest
-(id)initWithUsername:(NSString *)usrname password:(NSString *)passwrd{
    self=[super init];
    self.username=usrname;
    self.password=passwrd;
    return self;
}

@end
