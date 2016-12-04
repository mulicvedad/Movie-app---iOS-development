#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

#import "DataStorageProtocol.h"
#import "MovieDb.h"
#import "Movie.h"
#import "TVShowDb.h"
#import "TVShow.h"
#import "TVShowSeasonDb.h"
#import "TvShowSeason.h"
#import "TVShowEpisodeDb.h"
#import "TVShowEpisode.h"
#import "CastMemberDb.h"
#import "CastMember.h"
#import "CrewMemberDb.h"
#import "CrewMember.h"
#import "ImageDb.h"
#import "Image.h"
#import "ReviewDb.h"
#import "TVEventReview.h"
#import "PersonDetailsDb.h"
#import "PersonDetails.h"
#import "IntegerObjectDb.h"

@interface DatabaseManager : NSObject<DataStorageProtocol>
+(instancetype)sharedDatabaseManager;
-(void)removeAllITVEventsFromCollection:(CollectionType)collectionType;
-(void)addTVEventsFromArray:(NSArray *)tvEvents toCollection:(CollectionType)collection;
-(void)addTVShowSeason:(TvShowSeason *)season;
-(void)addTVShowSeasonsFromArray:(NSArray *)seasons;
-(void)addTVShowEpisode:(TVShowEpisode *)episode;
-(void)addTVShowEpisodesFromArray:(NSArray *)episode;
-(void)addCastMember:(CastMember *)castMember;
-(void)addCastMembersFromArray:(NSArray *)castMembers;
-(void)addCrewMember:(CrewMember *)crewMember;
-(void)addCrewMembers:(NSArray *)crewMembers;
-(void)addImage:(Image *)image;
-(void)addImagesFromArray:(NSArray *)images;
-(void)addPerson:(PersonDetails *)person;
-(void)addReview:(TVEventReview *)review;
-(void)addReviewsFromArray:(TVEventReview *)reviews;
-(TVEvent *)getTVEventWithID:(NSInteger)tvEventID mediaType:(MediaType)mediaType;
-(Movie *)getMovieWithID:(NSInteger)movieID;
-(TVShow *)getTVShowWithID:(NSInteger)tvShowID;
-(NSArray *)getSeasonsForTVShow:(TVShow *)tvShow;
-(NSArray *)getEpisodesForTVShow:(TVShow *)tvShow seasonNumber:(NSInteger)seasonNumber;
-(NSArray *)getMoviesOfCollection:(CollectionType)collection;
-(NSArray *)getTVShowsOfCollection:(CollectionType)collection;
-(NSArray *)getCastMembersForTVEvent:(TVEvent *)tvEvent;
-(NSArray *)getCrewMembersForTVEvent:(TVEvent *)tvEvent;
-(NSArray *)getImagesForTVEvent:(TVEvent *)tvEvent;
-(NSArray *)getReviewsForTVEvent:(TVEvent *)tvEvent;

-(void)updateTVEvent:(NSInteger)tvEventID withTVEventDetails:(TVEventDetails *)tvEventDetails;


@end
