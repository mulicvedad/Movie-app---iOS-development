#import <Realm/Realm.h>

@interface PersonDb : RLMObject
@property NSInteger id;
@property NSDate *birthDate;
@property NSString *name;
@property NSString *city;
@end

