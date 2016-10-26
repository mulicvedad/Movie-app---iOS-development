#import "TVEventCreditsTableViewCell.h"

#define FontSize12 12

@implementation TVEventCreditsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureView];
}

-(void)configureView{
    UIFont *prefferedFont=[MovieAppConfiguration getPreferredFontWithSize:FontSize12 isBold:NO];
    self.directorLabelLeft.font=prefferedFont;
    self.directrorLabelRight.font=prefferedFont;
    self.writersLabelLeft.font=prefferedFont;
    self.writersLabelRight.font=prefferedFont;
    self.starsLabelLeft.font=prefferedFont;
    self.starsLabelRight.font=prefferedFont;
    [self.starsLabelRight setPreferredMaxLayoutWidth:self.frame.size.width/2];
    [self.writersLabelRight setPreferredMaxLayoutWidth:self.frame.size.width/2];

}
+(NSString *)cellIdentifier{
    return [self cellIClassName];
}
+(NSString *)cellIClassName{
    return @"TVEventCreditsTableViewCell";
}

-(void)setupWithDirector:(NSString *)director writers:(NSString *)writers stars:(NSString *)stars{
    self.directrorLabelRight.text=[director length]==0 ? @"Not Found" : director;
    self.writersLabelRight.text=[writers length]==0 ? @"Not Found" : writers;
    self.starsLabelRight.text=[stars length]==0 ? @"Not Found" : stars;
}

@end
