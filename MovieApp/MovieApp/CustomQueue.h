#import <Foundation/Foundation.h>

//my NSMutableArray wrapper
@interface CustomQueue : NSObject
-(NSUInteger)count;
+(instancetype)queueWithArray:(NSArray *)objects;
-(void)enqueue:(id)object;
-(id)dequeue;
-(void)removeAllObjects;
@end
