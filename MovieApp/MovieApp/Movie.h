#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Movie : NSObject <NSCoding>

@property (nonatomic) NSUInteger id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *poster_path;
@property (nonatomic, strong) NSString *overview;
@property (nonatomic, strong) NSDate *release_date;
@property (nonatomic, strong) NSArray *genre_ids;
@property (nonatomic, strong) NSString *original_language;
@property (nonatomic) float vote_average;
@property (nonatomic) NSUInteger vote_count;
@property (nonatomic, strong) NSData *posterImageData;

+(NSArray *)getPropertiesNames;
+(void)saveMovie:(Movie *)movie;
+(Movie *)loadMovieForID:(NSUInteger)movie_id;
+(void)saveArrayOfMovies:(NSArray *)movies forKey:(NSString *)key;
+(NSArray *)loadArrayOfMoviesForKey:(NSString *)key;
@end
