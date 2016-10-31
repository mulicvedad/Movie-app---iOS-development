#import <Foundation/Foundation.h>

@interface TVEventCredit : NSObject
@property (nonatomic) NSUInteger id;
@property (nonatomic) NSUInteger creditID;
@property (nonatomic, strong) NSString *character;
@property (nonatomic, strong) NSString *posterPath;
@property (nonatomic, strong) NSString *mediaType;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *title;


+(NSDictionary *)propertiesMapping;


@end
