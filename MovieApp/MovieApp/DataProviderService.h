#import <Foundation/Foundation.h>
#import "ItemsArrayReceiver.h"
#import "TVEvent.h"

typedef enum Criteria
{
    MOST_POPULAR=0,
    LATEST=1,
    TOP_RATED=2,
    AIRING_TODAY=3,
    ON_THE_AIR=4
    
}Criterion;
//singleton
@interface DataProviderService : NSObject
+(DataProviderService *)sharedDataProviderService;
-(void)configure;
-(void)getTvEventsByCriterion:(Criterion)criterion returnToHandler:(id<ItemsArrayReceiver>)delegate;
+(NSArray *)getCriteriaForSorting;
-(void)getGenresForTvEvent:(Class)class ReturnTo:(id<ItemsArrayReceiver>)dataHandler;
-(void)getDetailsForTvEvent:(TVEvent *)tvEvent returnTo:(id<ItemsArrayReceiver>)dataHandler;
-(void)getCreditsForTvEvent:(TVEvent *)tvEvent returnTo:(id<ItemsArrayReceiver>)dataHandler;

-(void)getVideosForTvEventID:(NSUInteger)tvEventID returnTo:(id<ItemsArrayReceiver>)dataHandler;
-(void)getSeasonDetailsForTvShow:(NSUInteger)tvShowID seasonNumber:(NSUInteger)number returnTo:(id<ItemsArrayReceiver>)dataHandler;
-(void)getVideosForTvShowID:(NSUInteger)tvShowID seasonNumber:(NSUInteger)seasonNumber episodeNumber:(NSUInteger)episodeNumber returnTo:(id<ItemsArrayReceiver>)dataHandler;
-(void)getCastForTvShowID:(NSUInteger)tvShowID seasonNumber:(NSUInteger)seasonNumber episodeNumber:(NSUInteger)episodeNumber returnTo:(id<ItemsArrayReceiver>)dataHandler;
-(void)performMultiSearchWithQuery:(NSString *)query returnTo:(id<ItemsArrayReceiver>)dataHandler;
@end
