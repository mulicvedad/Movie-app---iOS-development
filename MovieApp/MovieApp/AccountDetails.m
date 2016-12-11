#import "AccountDetails.h"

@implementation AccountDetails
+(NSDictionary *)propertiesMapping{
    return @{@"id":@"id",
             @"name":@"name",
             @"username":@"username"
             };
}

+(AccountDetails *)accountDetailsWithAccountDetailsDb:(AccountDetailsDb *)accountDetailsDb{
    AccountDetails *newAccount=[[AccountDetails alloc] init];
    
    newAccount.id=accountDetailsDb.id;
    newAccount.name=accountDetailsDb.name;
    newAccount.username=accountDetailsDb.username;
    
    return newAccount;
}
@end
