#import <Foundation/Foundation.h>
#import "TVEvent.h"

@protocol DataStorageProtocol <NSObject>

-(NSArray *)getFavoriteTVEventsOfType:(MediaType)mediaType;
-(NSArray *)getWatchlistOfType:(MediaType)mediaType;
-(NSArray *)getRatedTVEventsOfType:(MediaType)mediaType;
-(void)updateData;
-(void)removeAllData;
-(BOOL)containsTVEventInFavorites:(TVEvent *)tvEvent;
-(BOOL)containsTVEventInWatchlist:(TVEvent *)tvEvent;
-(BOOL)containsTVEventInRatings:(TVEvent *)tvEvent;
-(void)removeTVEventWithID:(NSInteger)tvEventID mediaType:(MediaType)mediatype fromCollection:(CollectionType)collectionType;
-(void)addTVEvent:(TVEvent *)tvEvent toCollection:(CollectionType)collectionType;

@end
