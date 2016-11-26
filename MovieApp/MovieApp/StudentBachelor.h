#import "PersonDb.h"
#import "Pet.h"

RLM_ARRAY_TYPE(Pet)

@interface StudentBachelor : PersonDb
@property PersonDb *person;
@property NSInteger yearOfGraduation;
@property RLMArray<Pet *><Pet> *pets;
@end
