#import "NewsFeedItemView.h"

@implementation NewsFeedItemView

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self)
    {
        [[NSBundle mainBundle] loadNibNamed:@"NewsFeedItem" owner:self options:nil];
        
        [self addSubview:_feedView];
    }
    
    return self;
    
}

@end
