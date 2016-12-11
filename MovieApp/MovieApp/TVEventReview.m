#import "TVEventReview.h"

@implementation TVEventReview

+(NSArray *)propertiesNames{
    return @[@"id",@"author",@"content",@"url"];
}

+(TVEventReview *)reviewWithReviewDb:(ReviewDb *)reviewDb{
    TVEventReview *newReview=[[TVEventReview alloc] init];
    
    newReview.id=reviewDb.id;
    newReview.author=reviewDb.author;
    newReview.content=reviewDb.content;
    newReview.url=reviewDb.url;
    
    return newReview;
}

+(NSArray *)reviewsArrayWithRLMArray:(RLMResults *)results{
    NSMutableArray *newReviews=[[NSMutableArray alloc] init];
    
    for(ReviewDb *reviewDb in results){
        [newReviews addObject:[TVEventReview reviewWithReviewDb:reviewDb]];
    }
    
    return newReviews;
}

@end
