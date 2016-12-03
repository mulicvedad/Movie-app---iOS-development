#import <Foundation/Foundation.h>
#import "DataStorageProtocol.h"
#import "DataProviderService.h"
#import "ItemsArrayReceiver.h"

@interface VirtualDataStorage : NSObject<DataStorageProtocol, ItemsArrayReceiver>

+(VirtualDataStorage *)sharedVirtualDataStorage;
-(void)beginEpisodesFetching;

@end
