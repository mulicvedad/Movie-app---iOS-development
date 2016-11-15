#import <Foundation/Foundation.h>

@protocol AddTVEventToCollectionDelegate <NSObject>

@optional
-(void)addTVEventToCollection:(SideMenuOption)typeOfCollection indexPathRow:(NSUInteger)indexPathRow;
-(void)addTVEventWithID:(NSUInteger)tvEventID toCollection:(SideMenuOption)typeOfCollection;
-(void)didSelectRateThisTVEvent;
@end
