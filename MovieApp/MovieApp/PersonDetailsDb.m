#import "PersonDetailsDb.h"
#import "PersonDetails.h"

@implementation PersonDetailsDb

+(NSString *)primaryKey{
    return @"id";
}


+(PersonDetailsDb *)personDetailsDbWithPersonDetails:(PersonDetails *)personDetails{
    PersonDetailsDb *newPersonDb=[[PersonDetailsDb alloc] init];
    
    newPersonDb.id=personDetails.id;
    newPersonDb.name=personDetails.name;
    newPersonDb.placeOfBirth=personDetails.placeOfBirth;
    newPersonDb.profilePath=personDetails.profilePath;
    newPersonDb.homepageUrlPath=personDetails.homepageUrlPath;
    newPersonDb.biography=personDetails.biography;
    newPersonDb.birthday=personDetails.birthday;
    newPersonDb.deathday=personDetails.deathday;
    
    return newPersonDb;
}

@end
