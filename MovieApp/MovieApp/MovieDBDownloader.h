#import <Foundation/Foundation.h>
#import "ItemsArrayReceiver.h"
#import <UIKit/UIKit.h>
#import "Movie.h"

typedef enum Criteria
{
    MOST_POPULAR,
    TOP_RATED,
    LATEST
}Criterion;

@interface MovieDBDownloader : NSObject
extern NSArray *niz;
-(void)configure;
-(void)getdMoviesByCriterion:(Criterion)criterion returnToHandler:(id<ItemsArrayReceiver>)delegate;
+(NSArray *)getCriterionsForSorting;

@end
