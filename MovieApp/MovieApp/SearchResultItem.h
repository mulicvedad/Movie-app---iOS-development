
#import <Foundation/Foundation.h>

@interface SearchResultItem : NSObject

@property (nonatomic) NSUInteger id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *originalTitle;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *originalName;
@property (nonatomic, strong) NSString *posterPath;
@property (nonatomic, strong) NSString *backdropPath;
@property (nonatomic, strong) NSString *overview;
@property (nonatomic, strong) NSDate *releaseDate;
@property (nonatomic, strong) NSDate *firstAirDate;
@property (nonatomic, strong) NSArray *genreIDs;
@property (nonatomic, strong) NSString *originalLanguage;
@property (nonatomic) float voteAverage;
@property (nonatomic) NSUInteger voteCount;

@property (nonatomic, strong) NSString *mediaType;

+(NSDictionary *)propertiesMapping;

@end
