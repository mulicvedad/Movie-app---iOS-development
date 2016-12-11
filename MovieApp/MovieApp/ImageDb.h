#import <Realm/Realm.h>
#import <UIKit/UIKit.h>
#import <SDWebImageDownloader.h>

@class Image;

@interface ImageDb : RLMObject

@property NSData *imageData;
@property float aspectRatio;
@property NSString *fullUrlPath;
@property NSString *filePath;

+(ImageDb *)imageDbWithImage:(Image *)image baseUrl:(NSString *)baseUrl imageAsData:(NSData *)imageDataOrNil;
@end

RLM_ARRAY_TYPE(ImageDb)
