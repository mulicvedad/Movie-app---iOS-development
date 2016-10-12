#import "ReviewSeparatorTableViewCell.h"

#define SEPARATOR_CELL_WIDTH_HEIGHT_RATIO 18.75

@implementation ReviewSeparatorTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor=[UIColor yellowColor];
    
}

-(void)setup{
    self.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.width/SEPARATOR_CELL_WIDTH_HEIGHT_RATIO);
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, self.frame.size.height/2, self.frame.size.width-20, 1)];
    lineView.backgroundColor = [UIColor darkGrayColor];
    [self addSubview:lineView];
}
+(NSString *)cellIdentifier{
    return [self cellIClassName];
}

+(NSString *)cellIClassName{
    return @"ReviewSeparatorTableViewCell";
}

@end
