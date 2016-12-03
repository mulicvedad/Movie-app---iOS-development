#import <Realm/Realm.h>

@interface GenreDb : RLMObject

@property NSInteger id;
@property NSString *genreName;
@property BOOL isMovieGenre;

@end

RLM_ARRAY_TYPE(GenreDb)
