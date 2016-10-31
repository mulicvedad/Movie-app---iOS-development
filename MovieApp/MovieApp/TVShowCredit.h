#import "TVEventCredit.h"

@interface TVShowCredit : NSObject 
@property (nonatomic) NSUInteger id;
@property (nonatomic) NSUInteger creditID;
@property (nonatomic, strong) NSString *character;
@property (nonatomic, strong) NSString *releaseDate;
@property (nonatomic, strong) NSString *posterPath;
@property (nonatomic, strong) NSString *mediaType;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *originalName;
@property (nonatomic) NSUInteger episodeCount;

+(NSDictionary *)propertiesMapping;
@end
