#import <Foundation/Foundation.h>

@interface PersonDetails : NSObject
@property (nonatomic) NSUInteger id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *placeOfBirth;
@property (nonatomic, strong) NSString *profilePath;
@property (nonatomic, strong) NSString *homepageUrlPath;
@property (nonatomic, strong) NSString *biography;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *deathday;

+(NSDictionary *)propertiesMapping;
-(NSString *)getBirthInfo;

@end
