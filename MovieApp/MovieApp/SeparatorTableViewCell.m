#import "SeparatorTableViewCell.h"

@implementation SeparatorTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}


+(NSString *)cellIdentifier{
    return [self cellIClassName];
}
+(NSString *)cellIClassName{
    return  @"SeparatorTableViewCell";
}


@end
