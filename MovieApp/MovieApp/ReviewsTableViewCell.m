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
    _readMoreTextView.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:248/255.0 green:202/255.0 blue:0/255.0 alpha:0.5]};

    _readMoreTextView.attributedText=sourceLink;
}

+(NSString *)cellIdentifier{
    return [self cellIClassName];
}

+(NSString *)cellIClassName{
    return @"ReviewsTableViewCell";
}

@end
