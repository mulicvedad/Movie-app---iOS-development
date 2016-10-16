#import "FeedTableViewCell.h"
#import "MovieAppConfiguration.h"

#define LINK_FONT_SIZE 12

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
    
    NSAttributedString *sourceLink = [[NSAttributedString alloc] initWithString:@"See more details" attributes:@{NSForegroundColorAttributeName:[MovieAppConfiguration getPrefferedYellowColor], NSFontAttributeName:[MovieAppConfiguration getPreferredFontWithSize:LINK_FONT_SIZE],NSLinkAttributeName:url}];
    
    _linkTextView.attributedText=sourceLink;
        
}


@end
