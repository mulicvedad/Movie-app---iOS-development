#import <Foundation/Foundation.h>
#import "ImageDb.h"

@interface Image : NSObject
@property (nonatomic) float aspectRatio;
@property (nonatomic,strong) NSString *filePath;

+(NSDictionary *)propertiesMapping;
+(NSArray *)getURLsFromImagesArray:(NSArray *)images;

+(Image *)imageWithImageDb:(ImageDb *)imageDb;
+(NSArray *)imagesArrayFromRLMArray:(RLMResults *)results;
@end
