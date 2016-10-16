#import "SeparatorTableViewCell.h"

@implementation SeparatorTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}


+(NSString *)cellIdentifier{
    return [self cellIClassName];
}
+(NSString *)cellIClassName{
    return  @"SeparatorTableViewCell";
}


@end
