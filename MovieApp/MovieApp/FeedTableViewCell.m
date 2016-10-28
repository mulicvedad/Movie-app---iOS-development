#import "FeedTableViewCell.h"

#define FontSIze12 12

@implementation FeedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}


+ (CGFloat)cellHeight{
    return 200;
}

+ (NSString *)cellIdentifier{
    return @"feedCell";
}
+(NSString *)cellViewClassName{
    return @"FeedTableViewCell";
}

-(void)setupWithHeadline:(NSString *)pHeadline text:(NSString *)pText sourceUrlPath:(NSString *)pUrlPath{
    _descriptionLabel.text=pText;
    
    NSString *cleanUrl = [pUrlPath stringByTrimmingCharactersInSet:
                          [NSCharacterSet characterSetWithCharactersInString: @"\n "]];
    NSString *cleanHeadline = [pHeadline stringByTrimmingCharactersInSet:
                               [NSCharacterSet characterSetWithCharactersInString: @"\n "]];
    _headlineLabel.text=cleanHeadline;
    NSURL *url = [NSURL URLWithString:cleanUrl];
    
    NSAttributedString *sourceLink = [[NSAttributedString alloc] initWithString:@"See more details" attributes:@{NSForegroundColorAttributeName:[MovieAppConfiguration getPrefferedYellowColor], NSFontAttributeName:[MovieAppConfiguration getPreferredFontWithSize:FontSIze12 isBold:NO],NSLinkAttributeName:url}];
    
    _linkTextView.attributedText=sourceLink;
        
}

-(void)setupWithNewsFeedItem:(NewFeedsItem *)newsFeedItem{
    _descriptionLabel.text=newsFeedItem.text;
    
    NSString *cleanUrl = [newsFeedItem.sourceUrlPath stringByTrimmingCharactersInSet:
                          [NSCharacterSet characterSetWithCharactersInString: @"\n "]];
    NSString *cleanHeadline = [newsFeedItem.headline stringByTrimmingCharactersInSet:
                               [NSCharacterSet characterSetWithCharactersInString: @"\n "]];
    _headlineLabel.text=cleanHeadline;
    NSURL *url = [NSURL URLWithString:cleanUrl];
    
    NSAttributedString *sourceLink = [[NSAttributedString alloc] initWithString:@"See more details" attributes:@{NSForegroundColorAttributeName:[MovieAppConfiguration getPrefferedYellowColor], NSFontAttributeName:[MovieAppConfiguration getPreferredFontWithSize:FontSIze12 isBold:NO],NSLinkAttributeName:url}];
    
    _linkTextView.attributedText=sourceLink;
}



@end
