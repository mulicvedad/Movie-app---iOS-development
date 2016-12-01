#import <Realm/Realm.h>
#import "CastMemberDb.h"
#import "CrewMemberDb.h"
#import "ImageDb.h"
#import "IntegerObjectDb.h"

@interface TVEventDb : RLMObject

@property NSInteger id;
@property NSString *title;
@property NSString *originalTitle;
@property NSString *posterPath;
@property NSString *backdropPath;
@property NSString *overview;
@property NSDate *releaseDate;
@property NSString *originalLanguage;
@property float voteAverage;
@property NSInteger voteCount;
@property BOOL isInFavorites;
@property BOOL isInWatchlist;
@property BOOL isInRatings;
@property BOOL isInLatest;
@property BOOL isInPopular;
@property BOOL isInHighestRated;
@property float usersRating;
@property NSInteger duration;
@property RLMArray<IntegerObjectDb *><IntegerObjectDb> *genreIDs;
@property RLMArray<CastMemberDb *><CastMemberDb> *castMembers;
@property RLMArray<CrewMemberDb *><CrewMemberDb> *crewMembers;
@property RLMArray<ImageDb *><ImageDb> *images;

@end
