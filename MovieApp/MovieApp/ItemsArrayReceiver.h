#import <Foundation/Foundation.h>

@protocol ItemsArrayReceiver <NSObject>
-(void)updateViewWithNewData:(NSMutableArray *)customItemsArray;
@end
