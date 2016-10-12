#import <Foundation/Foundation.h>

@interface Image : NSObject
@property (nonatomic) float aspectRatio;
@property (nonatomic,strong) NSString *filePath;

+(NSDictionary *)propertiesMapping;
+(NSArray *)getURLsFromImagesArray:(NSArray *)images;
@end
