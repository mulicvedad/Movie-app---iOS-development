#import <Realm/Realm.h>

@interface ImageDb : RLMObject

@property NSData *imageData;
@property NSString *imageUrl;

@end

RLM_ARRAY_TYPE(ImageDb)
