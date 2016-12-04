#import <Realm/Realm.h>
#import <UIKit/UIKit.h>
#import <SDWebImageDownloader.h>

@class Image;

@interface ImageDb : RLMObject

@property NSData *imageData;
@property NSString *imageUrl;

@end

RLM_ARRAY_TYPE(ImageDb)
