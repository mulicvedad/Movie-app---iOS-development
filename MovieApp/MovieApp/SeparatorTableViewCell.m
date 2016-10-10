#import "SeparatorTableViewCell.h"

@implementation SeparatorTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, self.bounds.size.height/2, self.bounds.size.width, 1)];
    lineView.backgroundColor = [UIColor yellowColor];
    [self addSubview:lineView];

}


+(NSString *)cellIdentifier{
    return [self cellIClassName];
}
+(NSString *)cellIClassName{
    return  @"SeparatorTableViewCell";
}


@end
