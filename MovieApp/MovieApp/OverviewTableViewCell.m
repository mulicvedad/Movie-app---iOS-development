#import "OverviewTableViewCell.h"

#define HELVETICA_FONT @"HelveticaNeue"
#define FONT_SIZE_REGULAR 12

@implementation OverviewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureView];
}

-(void)configureView{
    UIFont *prefferedFont=[UIFont fontWithName:HELVETICA_FONT size:FONT_SIZE_REGULAR];
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
