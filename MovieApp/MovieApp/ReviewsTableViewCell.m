#import "ReviewsTableViewCell.h"

static NSString * const ReadMoreLinkText=@"Read more";
@implementation ReviewsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}


-(void)setupWithAuthorName:(NSString *)name reviewText:(NSString *)review readMoreURL:(NSURL *)url{
    _authorLabel.text=name;
    _reviewLabel.text=review;;
    
    NSAttributedString *sourceLink = [[NSAttributedString alloc] initWithString:ReadMoreLinkText attributes:@{
        NSLinkAttributeName:url}];
    _readMoreTextView.linkTextAttributes = @{NSForegroundColorAttributeName:[MovieAppConfiguration getPrefferedYellowColorWithOpacity:0.5f]};

    _readMoreTextView.attributedText=sourceLink;
}

-(void)setupWithReview:(TVEventReview *)review{
    _authorLabel.text=review.author;
    _reviewLabel.text=review.content;
    
    NSAttributedString *sourceLink = [[NSAttributedString alloc] initWithString:ReadMoreLinkText attributes:@{
                                                                                                                NSLinkAttributeName:[NSURL URLWithString:review.url]}];
    _readMoreTextView.linkTextAttributes = @{NSForegroundColorAttributeName:[MovieAppConfiguration getPrefferedYellowColorWithOpacity:0.5f]};
    
    _readMoreTextView.attributedText=sourceLink;
}

+(NSString *)cellIdentifier{
    return [self cellIClassName];
}

+(NSString *)cellIClassName{
    return @"ReviewsTableViewCell";
}

@end
