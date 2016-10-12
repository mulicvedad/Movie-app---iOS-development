#import <Foundation/Foundation.h>

@interface Person : NSObject
@property (nonatomic) NSUInteger id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *profileImageUrl;
@end
