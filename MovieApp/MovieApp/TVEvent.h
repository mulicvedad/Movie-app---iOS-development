#import <Foundation/Foundation.h>

@interface TVEvent : NSObject

@property (nonatomic) NSUInteger id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *originalTitle;
@property (nonatomic, strong) NSString *posterPath;
@property (nonatomic, strong) NSString *backdropPath;
@property (nonatomic, strong) NSString *overview;
@property (nonatomic, strong) NSDate *releaseDate;
@property (nonatomic, strong) NSArray *genreIDs;
@property (nonatomic, strong) NSString *originalLanguage;
@property (nonatomic) float voteAverage;
@property (nonatomic) NSUInteger voteCount;

-(NSString *)getGenreNameForId:(NSUInteger)genreId;
+(NSString *)getClassName;
-(NSString *)getFormattedReleaseDate;
-(NSString *)getFormattedGenresRepresentation;
-(NSString *)getReleaseYear;
@end
