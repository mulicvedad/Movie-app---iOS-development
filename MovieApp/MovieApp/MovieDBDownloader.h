#import <Foundation/Foundation.h>
#import "ItemsArrayReceiver.h"
#import <UIKit/UIKit.h>

typedef enum Criteria
{
    MOST_POPULAR=0,
    LATEST=1,
    TOP_RATED=2
    
}Criterion;

@interface MovieDBDownloader : NSObject
extern NSArray *niz;
-(void)configure;
-(void)getdMoviesByCriterion:(Criterion)criterion returnToHandler:(id<ItemsArrayReceiver>)delegate;
+(NSArray *)getCriteriaForSorting;

@end
