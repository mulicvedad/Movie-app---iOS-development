#import "TVEvent.h"

#define YEAR_FORMAT @"yyyy"

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
    for(int i=0;i<[self.genreIDs count];i++){
        NSUInteger currentID=[(NSNumber *)self.genreIDs[i] unsignedIntegerValue];
        [genresRepresentation appendString:[self getGenreNameForId:currentID]];
        
        if(i!=[self.genreIDs count]-1){
            [genresRepresentation appendString:@", " ];
        }
        
    }
    return genresRepresentation;
}

-(NSString *)getReleaseYear{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    NSString *dateString;
    [dateFormatter setDateFormat:YEAR_FORMAT];
    dateString=[dateFormatter stringFromDate:self.releaseDate];
    return dateString;
}
@end
