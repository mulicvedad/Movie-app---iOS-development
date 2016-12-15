#import "SeasonSelectionTableViewCell.h"

@implementation SeasonSelectionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configure];
}

-(void)configure{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

+(NSString *)cellIdentifier{
    return [self cellIClassName];
}

+(NSString *)cellIClassName{
    return @"SeasonSelectionTableViewCell";
}


@end
