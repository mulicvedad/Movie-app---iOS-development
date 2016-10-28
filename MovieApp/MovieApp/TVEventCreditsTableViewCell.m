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
-(void)setupWithCrew:(NSArray *)crew cast:(NSArray *)cast{
    
    NSString *directorsName=[CrewMember getDirectorsNameFromArray:crew];
    NSString *writersAsString=[CrewMember getWritersFromArray:crew];
    NSString *starsAsString=[CastMember getCastStringRepresentationFromArray:cast];
    self.directrorLabelRight.text=[directorsName length]==0 ? @"Not Found" : directorsName;
    self.writersLabelRight.text=[writersAsString length]==0 ? @"Not Found" : writersAsString;
    self.starsLabelRight.text=[starsAsString length]==0 ? @"Not Found" : starsAsString;
}
/*
 [cell setupWithDirector:[CrewMember getDirectorsNameFromArray:_crew] writers:[CrewMember getWritersFromArray:_crew] stars:[CastMember getCastStringRepresentationFromArray:_cast]];
 */

@end
