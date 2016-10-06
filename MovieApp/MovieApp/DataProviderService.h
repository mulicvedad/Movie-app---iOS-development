#import <Foundation/Foundation.h>
#import "ItemsArrayReceiver.h"
#import <UIKit/UIKit.h>

typedef enum Criteria
{
    MOST_POPULAR=0,
    LATEST=1,
    TOP_RATED=2,
    AIRING_TODAY=3,
    ON_THE_AIR=4
    
}Criterion;
//singleton
@interface DataProviderService : NSObject
+(DataProviderService *)sharedDataProviderService;
-(void)configure;
-(void)getTvEventsByCriterion:(Criterion)criterion returnToHandler:(id<ItemsArrayReceiver>)delegate;
+(NSArray *)getCriteriaForSorting;

@end
