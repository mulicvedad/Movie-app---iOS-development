#import <Realm/Realm.h>

@class TVEventReview;

@interface ReviewDb : RLMObject

@property NSInteger id;
@property NSString *author;
@property NSString *content;
@property NSString *url;

+(ReviewDb *)reviewDbWithReview:(TVEventReview *)review;

@end

RLM_ARRAY_TYPE(ReviewDb)
