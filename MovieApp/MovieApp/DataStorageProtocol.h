#import <Foundation/Foundation.h>

@protocol DataStorageProtocol <NSObject>

-(NSArray *)getFavoriteTVEventsOfType:(MediaType)mediaType;
-(NSArray *)getWatchlistOfType:(MediaType)mediaType;

@end
