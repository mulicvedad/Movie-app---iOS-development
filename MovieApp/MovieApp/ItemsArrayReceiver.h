#import <Foundation/Foundation.h>

@protocol ItemsArrayReceiver <NSObject>
-(void)updateReceiverWithNewData:(NSArray *)customItemsArray info:(NSDictionary *)info;
@end
