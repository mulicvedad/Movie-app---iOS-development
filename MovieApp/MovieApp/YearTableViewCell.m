#import "YearTableViewCell.h"

@implementation YearTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}

+(NSString *)cellIdentifier{
    return [self cellIClassName];
}

+(NSString *)cellIClassName{
    return @"YearTableViewCell";
}

@end
