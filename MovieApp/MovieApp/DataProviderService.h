#import <Foundation/Foundation.h>
#import "ItemsArrayReceiver.h"
#import "TVEvent.h"
#import "TheMovieDBConstants.h"
#import "LoginManagerDelagate.h"
#import "LoginRequest.h"
#import "TVEventsCollectionsStateChangeHandler.h"
#import "TVShow.h"

//singleton
@interface DataProviderService : NSObject<ItemsArrayReceiver>

+(DataProviderService *)sharedDataProviderService;
+(NSArray *)getCriteriaForSorting;
-(void)configure;
//GET methods
-(void)getTvEventsByCriterion:(Criterion)criterion page:(NSUInteger)page returnToHandler:(id<ItemsArrayReceiver>)delegate;
-(void)getGenresForTvEvent:(Class)class ReturnTo:(id<ItemsArrayReceiver>)dataHandler;
-(void)getDetailsForTvEvent:(TVEvent *)tvEvent returnTo:(id<ItemsArrayReceiver>)dataHandler;
-(void)getCreditsForTvEvent:(TVEvent *)tvEvent returnTo:(id<ItemsArrayReceiver>)dataHandler;
-(void)getVideosForTvEventID:(NSUInteger)tvEventID returnTo:(id<ItemsArrayReceiver>)dataHandler;
-(void)getSeasonDetailsForTvShow:(NSUInteger)tvShowID seasonNumber:(NSUInteger)number returnTo:(id<ItemsArrayReceiver>)dataHandler;
-(void)getVideosForTvShowID:(NSUInteger)tvShowID seasonNumber:(NSUInteger)seasonNumber episodeNumber:(NSUInteger)episodeNumber returnTo:(id<ItemsArrayReceiver>)dataHandler;
-(void)getCastForTvShowID:(NSUInteger)tvShowID seasonNumber:(NSUInteger)seasonNumber episodeNumber:(NSUInteger)episodeNumber returnTo:(id<ItemsArrayReceiver>)dataHandler;
-(void)performMultiSearchWithQuery:(NSString *)query page:(NSUInteger)page returnTo:(id<ItemsArrayReceiver>)dataHandler;
-(void)cancelAllRequests;
-(void)getPersonDetailsForID:(NSUInteger)personID returnTo:(id<ItemsArrayReceiver>)dataHandler;
-(void)getFavoriteTVEventsOfType:(MediaType)mediaType pageNumber:(NSUInteger)pageNumber returnTo:(id<ItemsArrayReceiver>)dataHandler;
-(void)getWatchlistOfType:(MediaType)mediaType pageNumber:(NSUInteger)pageNumber returnTo:(id<ItemsArrayReceiver>)dataHandler;
-(void)getRatedTVEventsOfType:(MediaType)mediaType pageNumber:(NSUInteger)pageNumber returnTo:(id<ItemsArrayReceiver>)dataHandler;

//POST methods
-(void)rateTVEventWithID:(NSUInteger)tvEventID rating:(CGFloat)rating mediaType:(MediaType)mediaType responseHandler:(id<TVEventsCollectionsStateChangeHandler>)responseHandler;
-(void)favoriteTVEventWithID:(NSUInteger)tvEventID mediaType:(MediaType)mediaType remove:(BOOL)shoulRemove responseHandler:(id<TVEventsCollectionsStateChangeHandler>)responseHandler;
-(void)addToWatchlistTVEventWithID:(NSUInteger)tvEventID mediaType:(MediaType)mediaType remove:(BOOL)shouldRemove responseHandler:(id<TVEventsCollectionsStateChangeHandler>)responseHandler;


-(void)getDetailsForTvEventWithID:(NSUInteger)tvEventID mediaType:(MediaType)mediaType returnTo:(id<ItemsArrayReceiver>)dataHandler;
-(void)getAllEpisodesForTVShowWithID:(NSUInteger)tvShowID numberOfSeasons:(NSUInteger)numberOfSeasons  returnTo:(id<ItemsArrayReceiver>)dataHandler;
-(void)getAccountDetailsReturnTo:(id<ItemsArrayReceiver>)dataHandler;
-(BOOL)isUserLoggedIn;

@end
