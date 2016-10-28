#import "OverviewTableViewCell.h"

#define FontSize12 12

@implementation OverviewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureView];
}

-(void)configureView{
    UIFont *prefferedFont=[MovieAppConfiguration getPreferredFontWithSize:FontSize12 isBold:NO];
    self.overviewLabel.font=prefferedFont;
}

-(void)setupWithOverview:(NSString *)overview{
    self.overviewLabel.text=overview;
}

+(NSString *)cellIdentifier{
    return [self cellIClassName];
}

+(NSString *)cellIClassName{
    return @"OverviewTableViewCell";
}
@end
