#import "PersonDetails.h"

static NSString * const DefaultDateFormat=@"dd MMMM yyyy";
static NSString * const BirthdayDateFormat=@"yyyy-mm-dd";

@implementation PersonDetails

+(NSDictionary *)propertiesMapping{
    return @{@"id":@"id",
             @"name":@"name",
             @"place_of_birth":@"placeOfBirth",
             @"homepage":@"homepageUrlPath",
             @"biography":@"biography",
             @"birthday":@"birthday",
             @"deathday":@"deathday"
             };
}

-(NSString *)getBirthInfo{
    NSMutableString *birthInfo=[[NSMutableString alloc] initWithString:@""];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:BirthdayDateFormat];
    if(self.birthday){
        NSDate *birthDate=[dateFormatter dateFromString:self.birthday];
        [dateFormatter setDateFormat:DefaultDateFormat];
        NSString *birthdayFormatted=[dateFormatter stringFromDate:birthDate];
        [birthInfo appendString:birthdayFormatted];
    }
    
    if(self.placeOfBirth){
        [birthInfo appendString:@", "];
        [birthInfo appendString:self.placeOfBirth];
    }
    return birthInfo;
}
@end
