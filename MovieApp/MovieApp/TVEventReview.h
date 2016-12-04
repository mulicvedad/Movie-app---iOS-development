#import <Foundation/Foundation.h>
#import "ReviewDb.h"

@interface TVEventReview : NSObject

@property (nonatomic) NSUInteger id;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *url;

+(NSArray *)propertiesNames;

+(TVEventReview *)reviewWithReviewDb:(ReviewDb *)reviewDb;
+(NSArray *)reviewsArrayWithRLMArray:(RLMResults *)results;
@end
