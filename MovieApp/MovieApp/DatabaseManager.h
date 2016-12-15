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
#import "ActionDb.h"
#import "AccountDetailsDb.h"
#import "AccountDetails.h"
#import "TVEventsCollectionsStateChangeHandler.h"

@interface DatabaseManager : NSObject<DataStorageProtocol, TVEventsCollectionsStateChangeHandler>

+(instancetype)sharedDatabaseManager;
-(void)removeAllTVEventsFromCollection:(CollectionType)collectionType;
-(void)removeTVEvent:(TVEvent *)tvEvent fromCollection:(CollectionType)collectionType;
-(void)removeTVEventWithID:(NSInteger)tvEventID mediaType:(MediaType)mediatype fromCollection:(CollectionType)collectionType;
-(void)addTVEventWithID:(NSInteger)tvEventId mediaType:(MediaType)mediaType toCollection:(CollectionType)collectionType;
-(void)addToRatingsTVEventWithID:(NSInteger)tvEventId mediaType:(MediaType)mediaType rating:(float)rating;
-(void)addTVEventsFromArray:(NSArray *)tvEvents toCollection:(CollectionType)collection;
-(void)addTVShowSeason:(TvShowSeason *)season toTVShowWithID:(NSInteger)tvShowID;
-(void)addTVShowSeasonsFromArray:(NSArray *)seasons toTVShowWithID:(NSInteger)tvShowID;
-(void)addTVShowEpisode:(TVShowEpisode *)episode toTVShow:(TVShow *)tvShow seasoNumber:(NSInteger)seasonNumber;
-(void)addTVShowEpisodesFromArray:(NSArray *)episodes toTVShow:(TVShow *)tvShow seasoNumber:(NSInteger)seasonNumber;
-(void)addTVShowEpisodesFromArray:(NSArray *)episodes toTVShowWithID:(NSInteger)tvShowID seasoNumber:(NSInteger)seasonNumber;
-(void)addCastMember:(CastMember *)castMember toTVEvent:(TVEvent *)tvEvent;;
-(void)addCastMembersFromArray:(NSArray *)castMembers toTVEvent:(TVEvent *)tvEvent;
-(void)addCrewMember:(CrewMember *)crewMember;
-(void)addCrewMembers:(NSArray *)crewMembers toTVEvent:(TVEvent *)tvEvent;
-(void)addUIImage:(UIImage *)image toImageDbWithID:(NSString *)imageDbID;
-(void)addImagesFromArray:(NSArray *)images toTVEvent:(TVEvent *)tvEvent;
-(void)addPerson:(PersonDetails *)person;
-(void)addReview:(TVEventReview *)review;
-(void)addReviewsFromArray:(NSArray *)reviews toMovie:(TVEvent *)movie;
-(void)addCastMembersFromArray:(NSArray *)castMembers toTVShowWithID:(NSInteger)tvShowID seasonNumber:(NSInteger)seasonNumber episodeNumber:(NSInteger)episodeNumber;
-(TVEvent *)getTVEventWithID:(NSInteger)tvEventID mediaType:(MediaType)mediaType;
-(Movie *)getMovieWithID:(NSInteger)movieID;
-(TVShow *)getTVShowWithID:(NSInteger)tvShowID;
-(PersonDetails *)getPersonDetailsForID:(NSInteger)personID;
-(NSArray *)getSeasonsForTVShow:(TVShow *)tvShow;
-(NSArray *)getEpisodesForTVShow:(TVShow *)tvShow seasonNumber:(NSInteger)seasonNumber;
-(NSArray *)getEpisodesForTVShowWithID:(NSInteger)tvShowID seasonNumber:(NSInteger)seasonNumber;
-(NSArray *)getMoviesOfCollection:(CollectionType)collection;
-(NSArray *)getTVShowsOfCollection:(CollectionType)collection;
-(NSArray *)getCastMembersForTVEvent:(TVEvent *)tvEvent;
-(NSArray *)getCrewMembersForTVEvent:(TVEvent *)tvEvent;
-(NSArray *)getImagesForTVEvent:(TVEvent *)tvEvent;
-(NSArray *)getReviewsForTVEvent:(TVEvent *)tvEvent;
-(NSArray *)getCastMembersForTVShowWithID:(NSInteger)tvShowID easonNumber:(NSInteger)seasonNumber episodeNumber:(NSInteger)episodeNumber;
-(UIImage *)getUIImageFromImageDbWithID:(NSString *)imageDbId;
-(void)updateTVEvent:(NSInteger)tvEventID withTVEventDetails:(TVEventDetails *)tvEventDetails;
-(NSInteger)getRatingForTVEvent:(TVEvent *)tvEvent;
-(void)offlineModeAddTVEventWithID:(NSInteger)tvEventId mediaType:(MediaType)mediaType toCollectionIn:(CollectionType)collectionType shouldRemove:(BOOL)shouldRemove;
-(void)offlineModeRateTVEventWithID:(NSInteger)tvEventID meidaType:(MediaType)mediaType rating:(NSInteger)rating;
-(void)connectionEstablished;
-(void)addAccountDetails:(AccountDetails *)accountDetails;
-(AccountDetails *)getAccountDetailsForID:(NSInteger)accountId;
-(NSArray *)getTVEventsForSearchQuery:(NSString *)query;
-(void)removeUserRelatedInfo;
-(void)addImageWithId:(NSString *)imageId toImageView:(UIImageView *)imageView;

@end
