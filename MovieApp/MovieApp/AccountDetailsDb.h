#import <Realm/Realm.h>

@class AccountDetails;

@interface AccountDetailsDb : RLMObject

@property NSInteger id;
@property NSString *name;
@property NSString *username;

+(AccountDetailsDb *)accountDetailsDbWithAccountDetails:(AccountDetails *)accountDetails;

@end
