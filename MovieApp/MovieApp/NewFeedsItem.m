#import "NewFeedsItem.h"

@implementation NewFeedsItem

@synthesize headline, text, sourceUrlPath;

- (instancetype)initWithHeadline:(NSString *)pheadline text:(NSString *)ptext sourceUrlPath:(NSString *)pwebPage
{
    self = [super init];
    headline=pheadline;
    text=ptext;
    sourceUrlPath=pwebPage;
    return self;
}

@end
