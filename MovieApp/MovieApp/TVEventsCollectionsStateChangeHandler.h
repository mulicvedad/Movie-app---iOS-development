#import <Foundation/Foundation.h>

@protocol TVEventsCollectionsStateChangeHandler <NSObject>

-(void)addedTVEventWithID:(NSUInteger)tvEventID toCollectionOfType:(SideMenuOption)typeOfCollection;
-(void)removedTVEventWithID:(NSUInteger)tvEventID fromCollectionOfType:(SideMenuOption)typeOfCollection;

@end
