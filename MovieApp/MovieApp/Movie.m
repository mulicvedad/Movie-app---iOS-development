

#import "Movie.h"

@implementation Movie

+(NSDictionary *)propertiesMapping{
    return @{@"id":@"id",
             @"title":@"title",
             @"vote_average":@"voteAverage",
             @"overview":@"overview",
             @"release_date":@"releaseDate",
             @"vote_count":@"voteCount",
             @"poster_path":@"posterPath",
             @"video":@"hasVideo",
             @"genre_ids":@"genreIDs",
             @"original_language":@"originalLanguage"};
}


//
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeInteger:self.id forKey:@"id"];
    [aCoder encodeInteger:self.voteCount forKey:@"vote_count"];
    [aCoder encodeFloat:self.voteAverage forKey:@"vote_average"];
    [aCoder encodeObject:self.overview forKey:@"overview"];
    [aCoder encodeObject:self.releaseDate forKey:@"release_date"];
    [aCoder encodeObject:self.posterPath forKey:@"poster_path"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self){
        self.title=[aDecoder decodeObjectForKey:@"title"];
        self.id=[aDecoder decodeIntegerForKey:@"id"];
        self.voteCount=[aDecoder decodeIntegerForKey:@"vote_count"];
        self.voteAverage=[aDecoder decodeFloatForKey:@"vote_average"];
        self.overview=[aDecoder decodeObjectForKey:@"overview"];
        self.releaseDate=[aDecoder decodeObjectForKey:@"release_date"];
        self.posterPath=[aDecoder decodeObjectForKey:@"poster_path"];
    }
    return self;
}
@end
