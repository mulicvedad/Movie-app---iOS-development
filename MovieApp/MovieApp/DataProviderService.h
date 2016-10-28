#import <Foundation/Foundation.h>
#import "ItemsArrayReceiver.h"
#import "TVEvent.h"
#import "TheMovieDBConstants.h"

//singleton
@interface DataProviderService : NSObject

+(DataProviderService *)sharedDataProviderService;
+(NSArray *)getCriteriaForSorting;
-(void)configure;
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

@end
