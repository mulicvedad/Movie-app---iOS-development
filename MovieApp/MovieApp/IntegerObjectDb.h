#import <Realm/Realm.h>

@interface IntegerObjectDb : RLMObject
@property NSInteger value;
@end

RLM_ARRAY_TYPE(IntegerObjectDb)
