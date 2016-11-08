#import <Foundation/Foundation.h>

@protocol AddTVEventToCollectionDelegate <NSObject>

-(void)addTVEventToCollection:(SideMenuOption)typeOfCollection indexPathRow:(NSUInteger)indexPathRow;

@end
