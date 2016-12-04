#import "ReviewDb.h"
#import "TVEventReview.h"

@implementation ReviewDb

+(NSString *)primaryKey{
    return @"id";
}

+(ReviewDb *)reviewDbWithReview:(TVEventReview *)review{
    ReviewDb *newReviewDb=[[ReviewDb alloc] init];
    
    newReviewDb.id=review.id;
    newReviewDb.author=review.author;
    newReviewDb.content=review.content;
    newReviewDb.url=review.url;
    
    return newReviewDb;
}
@end

