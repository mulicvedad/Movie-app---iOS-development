#import "TVEventCredit.h"

@interface MovieCredit : NSObject  
@property (nonatomic) NSUInteger id;
@property (nonatomic) NSUInteger creditID;
@property (nonatomic, strong) NSString *character;
@property (nonatomic, strong) NSString *releaseDate;
@property (nonatomic, strong) NSString *posterPath;
@property (nonatomic, strong) NSString *mediaType;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *originalTitle;

@property (nonatomic, strong) NSString *originalName;

+(NSDictionary *)propertiesMapping;
@end
