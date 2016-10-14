#import <Foundation/Foundation.h>

@interface Video : NSObject

@property (nonatomic) NSUInteger id;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *site;

+(NSArray *)propertiesNames;

@end
