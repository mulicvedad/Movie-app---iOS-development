#import "ReviewSeparatorTableViewCell.h"

static CGFloat const SeparatorCellWidthHeightRatio=18.75f;
@implementation ReviewSeparatorTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor=[UIColor yellowColor];
    
}

-(void)setupForCastMemberDetails{
    self.lineView.hidden=YES;
    self.frame=CGRectMake(0, 0, self.frame.size.width, 30);
    UIView *newLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height/2, self.frame.size.width-16, 1)];
    newLineView.backgroundColor = [MovieAppConfiguration getPrefferedGreyColor];
    [self addSubview:newLineView];
}
+(NSString *)cellIdentifier{
    return [self cellIClassName];
}

+(NSString *)cellIClassName{
    return @"ReviewSeparatorTableViewCell";
}

@end
