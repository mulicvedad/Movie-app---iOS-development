#import <Realm/Realm.h>

@interface PersonDetailsDb : RLMObject

@property NSInteger id;
@property NSString *name;
@property NSString *placeOfBirth;
@property NSString *profilePath;
@property NSString *homepageUrlPath;
@property NSString *biography;
@property NSString *birthday;
@property NSString *deathday;

@end
