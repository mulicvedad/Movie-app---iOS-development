#import "CastMemberInfoTableViewCell.h"

static NSString * const SeeFullBiographyText=@"See full bio";

@implementation CastMemberInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setupWithCastMember:(PersonDetails *)castMemeber{
    self.birthInfoLabel.text=[castMemeber getBirthInfo];
    self.biographyLabel.text=castMemeber.biography;
    NSAttributedString *websiteLink=[[NSAttributedString alloc] initWithString:castMemeber.homepageUrlPath attributes:@{NSLinkAttributeName:[NSURL URLWithString:castMemeber.homepageUrlPath], NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle), NSFontAttributeName:[MovieAppConfiguration getPreferredFontWithSize:14 isBold:NO]}];
    self.websiteTextView.attributedText=websiteLink;
    NSAttributedString *seeFullBiographyLink=[[NSAttributedString alloc] initWithString:SeeFullBiographyText attributes:@{NSLinkAttributeName:[NSURL URLWithString:castMemeber.homepageUrlPath], NSFontAttributeName:[MovieAppConfiguration getPreferredFontWithSize:14 isBold:NO]}];
    self.biographyLinkTextView.linkTextAttributes = @{NSForegroundColorAttributeName:[MovieAppConfiguration getPrefferedYellowColorWithOpacity:0.5f]};
    self.websiteTextView.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:74/255.0 green:144/255.0 blue:226/255.0 alpha:1.0]};
    self.biographyLinkTextView.attributedText=seeFullBiographyLink;
    if(!castMemeber.homepageUrlPath || [castMemeber.homepageUrlPath length]==0){
        self.websiteTextView.text=@"Not found";
        self.biographyLinkTextView.hidden=YES;
        self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height-30);
        [self setNeedsLayout];
    }

}

+(NSString *)cellClassName{
    return @"CastMemberInfoTableViewCell";
}

+(NSString *)cellIdentifier{
    return [self cellClassName];
}

@end
