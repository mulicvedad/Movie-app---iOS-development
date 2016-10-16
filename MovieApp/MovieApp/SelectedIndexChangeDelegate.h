#import <Foundation/Foundation.h>

@protocol SelectedIndexChangeDelegate <NSObject>

-(void)selectedIndexChangedTo:(NSUInteger)newIndex;

@end
