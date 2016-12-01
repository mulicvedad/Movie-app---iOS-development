#import "MovieDb.h"

@implementation MovieDb

+(NSString *)primaryKey{
    return @"id";
}
-(instancetype)initWithMovie:(Movie *)movie{
    self = [super init];
    self.id=movie.id;
    self.title=movie.title;
    self.originalTitle=movie.originalTitle;
    self.genreIDs = [[RLMArray<IntegerObjectDb *><IntegerObjectDb> alloc] initWithObjectClassName:NSStringFromClass([IntegerObjectDb class])];
    for(int i=0;i<movie.genreIDs.count;i++){
        IntegerObjectDb *genreId=[[IntegerObjectDb alloc] init];
        NSNumber *val=movie.genreIDs[i];
        genreId.value=[val integerValue];
        [self.genreIDs addObject:genreId];
    }
    self.posterPath=movie.posterPath;
    return self;
}

@end
