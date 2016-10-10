#import "TVEventCreditsTableViewCell.h"

#define HELVETICA_FONT @"HelveticaNeue"
#define FONT_SIZE_REGULAR 12

@implementation TVEventCreditsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureView];
}

-(void)configureView{
    UIFont *prefferedFont=[UIFont fontWithName:HELVETICA_FONT size:FONT_SIZE_REGULAR];
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
    self.directrorLabelRight.text=director;
    self.writersLabelRight.text=writers;
    self.starsLabelRight.text=stars;
}

@end
