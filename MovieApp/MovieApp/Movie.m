

#import "Movie.h"

@implementation Movie

+(NSArray *)getPropertiesNames{
    return @[@"id",@"title",@"vote_average",@"overview",@"release_date",@"vote_count",@"poster_path"];
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeInteger:self.id forKey:@"id"];
    [aCoder encodeInteger:self.vote_count forKey:@"vote_count"];
    [aCoder encodeFloat:self.vote_average forKey:@"vote_average"];
    [aCoder encodeObject:self.overview forKey:@"overview"];
    [aCoder encodeObject:self.release_date forKey:@"release_date"];
    [aCoder encodeObject:self.poster_path forKey:@"poster_path"];
    [aCoder encodeObject:self.posterImageData forKey:@"poster_image"];
 
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self){
        self.title=[aDecoder decodeObjectForKey:@"title"];
        self.id=[aDecoder decodeIntegerForKey:@"id"];
        self.vote_count=[aDecoder decodeIntegerForKey:@"vote_count"];
        self.vote_average=[aDecoder decodeFloatForKey:@"vote_average"];
        self.overview=[aDecoder decodeObjectForKey:@"overview"];
        self.release_date=[aDecoder decodeObjectForKey:@"release_date"];
        self.poster_path=[aDecoder decodeObjectForKey:@"poster_path"];
        self.posterImageData=[aDecoder decodeObjectForKey:@"poster_image"];
    }
    return self;
}

+(void)saveMovie:(Movie *)movie{
    NSData *movieObject=[NSKeyedArchiver archivedDataWithRootObject:movie];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:movieObject forKey:@"movie"];
    [defaults synchronize];
     
}
+(Movie *)loadMovieForID:(NSUInteger)movie_id{
    NSString *key=[NSString stringWithFormat:@"%d",(uint)movie_id];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *movieObject=[defaults objectForKey:key];
    Movie *actualMovie=[NSKeyedUnarchiver unarchiveObjectWithData:movieObject];
    
    return actualMovie;
}

+(void)saveArrayOfMovies:(NSArray *)movies forKey:(NSString *)key{
    NSMutableArray* arrayOfPropertyLists=[[NSMutableArray alloc]init];
    for(Movie *movie in movies)
    {
        NSData *movieObject=[NSKeyedArchiver archivedDataWithRootObject:movie];
        [arrayOfPropertyLists addObject:movieObject];

    }
    NSArray *arrayOfPLists=[NSArray arrayWithArray:arrayOfPropertyLists];
    [[NSUserDefaults standardUserDefaults] setObject:arrayOfPLists forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
+(NSArray *)loadArrayOfMoviesForKey:(NSString *)key{
    NSArray *moviesDataObjects=[[NSUserDefaults standardUserDefaults] objectForKey:key];
    NSMutableArray *moviesMutable=[[NSMutableArray alloc]init];
    for(NSData *movieObject in moviesDataObjects){
        [moviesMutable addObject:(Movie *)[NSKeyedUnarchiver unarchiveObjectWithData:movieObject]];
    }
    return [NSArray arrayWithArray: moviesMutable];
}

@end
