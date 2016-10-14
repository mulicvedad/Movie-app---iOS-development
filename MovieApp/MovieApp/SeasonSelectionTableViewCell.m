#import "SeasonSelectionTableViewCell.h"

@implementation SeasonSelectionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configure];
}

-(void)configure{
    
}

+(NSString *)cellIdentifier{
    return [self cellIClassName];
}

+(NSString *)cellIClassName{
    return @"SeasonSelectionTableViewCell";
}


@end
