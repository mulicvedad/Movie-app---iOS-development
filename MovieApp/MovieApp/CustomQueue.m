#import "CustomQueue.h"

@interface CustomQueue (){
    NSMutableArray *_queue;
}

@end

@implementation CustomQueue
-(instancetype)init{
    self=[super init];
    _queue=[[NSMutableArray alloc]init];
    return self;
}
+(instancetype)queueWithArray:(NSArray *)objects{
    CustomQueue *instance=nil;
    if(objects){
        instance=[[CustomQueue alloc] init];
        for(id obj in objects){
            [instance enqueue:obj];
        }
    }
    return instance;
}
-(void)enqueue:(id)object{
    if(_queue){
        [_queue addObject:object];
    }
}
-(id)dequeue{
    id object=nil;
    if([_queue count]>0){
        object=[_queue objectAtIndex:0];
        [_queue removeObjectAtIndex:0];
    }
    return object;
}
-(NSUInteger)count{
    return [_queue count];
}
-(void)removeAllObjects{
    [_queue removeAllObjects];
}
@end
