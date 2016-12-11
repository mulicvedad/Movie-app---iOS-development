#import <Realm/Realm.h>

@interface ActionDb : RLMObject

@property NSInteger tvEventID;
@property NSInteger mediaType;
@property NSInteger collection;
@property BOOL shouldRemove;
@property NSInteger rating;
@end
