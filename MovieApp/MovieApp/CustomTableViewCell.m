
#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

+(CGFloat)cellHeight{
    return 44;
}

+(NSString *)cellIdentifier{
    return nil;
}

+(NSString *)cellViewClassName{
    return @"FeedTableViewCell";
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
