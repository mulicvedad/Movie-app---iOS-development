#import "FeedTableViewCell.h"

@implementation FeedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
    _headlineLabel.text=pHeadline;
    _descriptionLabel.text=pText;

    NSString *cleanUrl = [pUrlPath stringByTrimmingCharactersInSet:
                          [NSCharacterSet characterSetWithCharactersInString: @"\n "]];
    
    NSURL *url = [NSURL URLWithString:cleanUrl];
    
    NSAttributedString *sourceLink = [[NSAttributedString alloc] initWithString:@"See more details" attributes:@{NSForegroundColorAttributeName:[UIColor yellowColor], NSFontAttributeName:[UIFont systemFontOfSize:13],NSLinkAttributeName:url}];
    
    _linkTextView.attributedText=sourceLink;

}

@end
