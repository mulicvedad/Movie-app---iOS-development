#import <Foundation/Foundation.h>

@interface TVEventDetails : NSObject

@property (nonatomic) NSUInteger id;
@property (nonatomic) NSUInteger duration;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *backdropPath;
@property (nonatomic, strong) NSString *overview;
@property (nonatomic, strong) NSDate *releaseDate;
@property (nonatomic) float voteAverage;
@property (nonatomic, strong) NSString *posterPath;

@end
