#import <Foundation/Foundation.h>
#import "ItemsArrayReceiver.h"

@interface TVEvent : NSObject <ItemsArrayReceiver>

@property (nonatomic) NSUInteger id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *posterPath;
@property (nonatomic, strong) NSString *overview;
@property (nonatomic, strong) NSDate *releaseDate;
@property (nonatomic, strong) NSArray *genreIDs;
@property (nonatomic, strong) NSString *originalLanguage;
@property (nonatomic) float voteAverage;
@property (nonatomic) NSUInteger voteCount;

+(NSDictionary *)propertiesMapping;
+(void)initializeGenres:(NSArray *)genresArray;
-(NSString *)getGenreNameForId:(NSUInteger)genreId;
+(NSString *)getClassName;

@end
