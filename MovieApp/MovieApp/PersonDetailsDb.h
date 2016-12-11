#import <Realm/Realm.h>

@class PersonDetails;

@interface PersonDetailsDb : RLMObject

@property NSInteger id;
@property NSString *name;
@property NSString *placeOfBirth;
@property NSString *profilePath;
@property NSString *homepageUrlPath;
@property NSString *biography;
@property NSString *birthday;
@property NSString *deathday;

+(PersonDetailsDb *)personDetailsDbWithPersonDetails:(PersonDetails *)personDetails;
@end
