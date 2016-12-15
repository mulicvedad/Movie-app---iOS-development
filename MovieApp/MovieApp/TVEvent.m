#import "TVEvent.h"

static NSString * const YearDateFormat=@"yyyy";

@implementation TVEvent


//abstract method
-(NSString *)getGenreNameForId:(NSUInteger)genreId{
    return nil;
}

+(NSString *)getClassName{
    return @"TVEvent";
}

//abstract method
-(NSString *)getFormattedReleaseDate{
    return nil;
}

-(NSString *)getFormattedGenresRepresentation{
    NSMutableString *genresRepresentation=[NSMutableString stringWithString:@""];
    for(int i=0;i<[self.genreIDs count] && i<3;i++){
        NSUInteger currentID=[(NSNumber *)self.genreIDs[i] unsignedIntegerValue];
        [genresRepresentation appendString:[self getGenreNameForId:currentID]];
        
        if(i!=[self.genreIDs count]-1 && i!=2){
            [genresRepresentation appendString:@", " ];
        }
        
    }
    [genresRepresentation stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
    return genresRepresentation;
}

-(NSString *)getReleaseYear{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    NSString *dateString=@"";
    if(self.releaseDate){
        [dateFormatter setDateFormat:YearDateFormat];
        dateString=[dateFormatter stringFromDate:self.releaseDate];
    }
    
    return dateString;
}

-(void)setupWithTVEventDetails:(TVEventDetails *)tvEventDetails{
    self.title=tvEventDetails.title;
    self.originalTitle=tvEventDetails.title;
    self.releaseDate=tvEventDetails.releaseDate;
    self.backdropPath=tvEventDetails.backdropPath;
    self.posterPath=tvEventDetails.posterPath;
    self.overview=tvEventDetails.overview;
    self.voteAverage=tvEventDetails.voteAverage;
    self.duration=tvEventDetails.duration;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:[NSNumber numberWithUnsignedInteger:self.id] forKey:@"id"];
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:[NSNumber numberWithFloat:self.voteAverage] forKey:@"voteAverage"];
    [encoder encodeObject:self.posterPath forKey:@"posterPath"];
    [encoder encodeObject:self.overview forKey:@"overview"];
    
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        
        NSNumber *numId=[decoder decodeObjectForKey:@"id"];
        NSNumber *numVoteAverage=[decoder decodeObjectForKey:@"voteAverage"];
        self.id = [numId unsignedIntegerValue];
        self.title = [decoder decodeObjectForKey:@"title"];
        self.posterPath = [decoder decodeObjectForKey:@"posterPath"];
        self.voteAverage=[numVoteAverage floatValue];
        self.overview=[decoder decodeObjectForKey:@"overview"];
    }
    return self;
}

@end
