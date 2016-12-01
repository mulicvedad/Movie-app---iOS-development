#import <Realm/Realm.h>

@interface ReviewDb : RLMObject

@property NSInteger id;
@property NSString *author;
@property NSString *content;
@property NSString *url;

@end

RLM_ARRAY_TYPE(ReviewDb)
