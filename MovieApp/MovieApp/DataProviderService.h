#import <Foundation/Foundation.h>
#import "ItemsArrayReceiver.h"
#import "TVEvent.h"
#import "TheMovieDBConstants.h"
#import "LoginManagerDelagate.h"
#import "LoginRequest.h"
#import "LoginManager.h"

//singleton
@interface DataProviderService : NSObject<LoginManagerDelegate>

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
-(void)loginWithLoginRequest:(LoginRequest *)loginData delegate:(id<LoginManagerDelegate>)delegate;

-(void)getFavoriteTVEventsOfType:(MediaType)mediaType pageNumber:(NSUInteger)pageNumber returnTo:(id<ItemsArrayReceiver>)dataHandler;
-(void)getWatchlistOfType:(MediaType)mediaType pageNumber:(NSUInteger)pageNumber returnTo:(id<ItemsArrayReceiver>)dataHandler;
-(void)getRatedTVEventsOfType:(MediaType)mediaType pageNumber:(NSUInteger)pageNumber returnTo:(id<ItemsArrayReceiver>)dataHandler;

//POST methods
-(void)rateTVEventWithID:(NSUInteger)tvEventID rating:(CGFloat)rating mediaType:(MediaType)mediaType;
-(void)favoriteTVEventWithID:(NSUInteger)tvEventID mediaType:(MediaType)mediaType remove:(BOOL)shoulRemove;
-(void)addToWatchlistTVEventWithID:(NSUInteger)tvEventID mediaType:(MediaType)mediaType remove:(BOOL)shouldRemove;

@end
