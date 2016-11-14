#import <Foundation/Foundation.h>
#import "TVEventDetails.h"

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
@property (nonatomic) BOOL isInFavorites;
@property (nonatomic) BOOL isInWatchlist;
@property (nonatomic) BOOL isInRatings;

-(NSString *)getGenreNameForId:(NSUInteger)genreId;
+(NSString *)getClassName;
-(NSString *)getFormattedReleaseDate;
-(NSString *)getFormattedGenresRepresentation;
-(NSString *)getReleaseYear;
-(void)setupWithTVEventDetails:(TVEventDetails *)tvEventDetails;
@end
