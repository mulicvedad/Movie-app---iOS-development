#import <Foundation/Foundation.h>

@protocol ItemsArrayReceiver <NSObject>
-(void)updateReceiverWithNewData:(NSMutableArray *)customItemsArray info:(NSDictionary *)info;
@end
