#import <Foundation/Foundation.h>

@interface WatchlistPostObject : NSObject

@property (nonatomic) NSUInteger mediaID;
@property (nonatomic, strong) NSString *mediaType;
@property (nonatomic) BOOL status;

-(id)initWithMediaID:(NSUInteger)mediaId mediaType:(MediaType)mediaType status:(BOOL)status;
+(NSDictionary *)propertiesMapping;
@end
