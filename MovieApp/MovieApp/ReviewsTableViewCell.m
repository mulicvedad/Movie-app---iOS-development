#import "ReviewsTableViewCell.h"

#define HELVETICA_FONT @"HelveticaNeue"
#define FONT_SIZE_REGULAR 12
#define READ_MORE @"Read more"

@implementation ReviewsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}


-(void)setupWithAuthorName:(NSString *)name reviewText:(NSString *)review readMoreURL:(NSURL *)url{
    _authorLabel.text=name;
    _reviewLabel.text=review;;
    
    NSAttributedString *sourceLink = [[NSAttributedString alloc] initWithString:READ_MORE attributes:@{
        NSLinkAttributeName:url}];
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
