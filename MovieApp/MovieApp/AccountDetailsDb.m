#import "AccountDetailsDb.h"
#import "AccountDetails.h"

@implementation AccountDetailsDb

+(NSString *)primaryKey{
    return @"id";
}

+(AccountDetailsDb *)accountDetailsDbWithAccountDetails:(AccountDetails *)accountDetails{
    AccountDetailsDb *newAccount=[[AccountDetailsDb alloc] init];
    
    newAccount.id=accountDetails.id;
    newAccount.name=accountDetails.name;
    newAccount.username=accountDetails.username;
    
    return newAccount;
}

@end
