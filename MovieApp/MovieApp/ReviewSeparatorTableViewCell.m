#import "ReviewSeparatorTableViewCell.h"

static CGFloat const SeparatorCellWidthHeightRatio=18.75f;
@implementation ReviewSeparatorTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor=[UIColor yellowColor];
    
}

-(void)setup{
    self.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.width/SeparatorCellWidthHeightRatio);
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, self.frame.size.height/2, self.frame.size.width-20, 1)];
    lineView.backgroundColor = [MovieAppConfiguration getPrefferedGreyColor];
    [self addSubview:lineView];
}
+(NSString *)cellIdentifier{
    return [self cellIClassName];
}

+(NSString *)cellIClassName{
    return @"ReviewSeparatorTableViewCell";
}

@end
