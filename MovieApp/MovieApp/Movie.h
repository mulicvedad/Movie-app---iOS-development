#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Movie : NSObject <NSCoding>

@property (nonatomic) NSUInteger id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *posterPath;
@property (nonatomic, strong) NSString *overview;
@property (nonatomic, strong) NSDate *releaseDate;
@property (nonatomic, strong) NSArray *genreIDs;
@property (nonatomic, strong) NSString *originalLanguage;
@property (nonatomic) BOOL hasVideo;
@property (nonatomic) float voteAverage;
@property (nonatomic) NSUInteger voteCount;

+(NSDictionary *)propertiesMapping;

@end
