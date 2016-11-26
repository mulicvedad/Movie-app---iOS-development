#import "CastMemberInfoTableViewCell.h"

typedef  enum{
    ButtonStateNormal,
    ButtonStateClicked
}ButtonState;
@interface CastMemberInfoTableViewCell (){
    id<ReloadContentHandler> _delegate;
}

@end

static NSString *SeeFullBiographyText=@"See full bio";
static NSString *HideBiographyText=@"Hide";
static NSString *NotFoundText=@"Not found";

@implementation CastMemberInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.seeFullBioButton.tag=0;
}

-(void)setupWithCastMember:(PersonDetails *)castMemeber delegate:(id<ReloadContentHandler>)delegate{
    _delegate=delegate;
    self.birthInfoLabel.text=[castMemeber getBirthInfo];
    self.biographyLabel.text=castMemeber.biography;
    NSAttributedString *websiteLink=[[NSAttributedString alloc] initWithString:castMemeber.homepageUrlPath attributes:@{NSLinkAttributeName:[NSURL URLWithString:castMemeber.homepageUrlPath], NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle), NSFontAttributeName:[MovieAppConfiguration getPreferredFontWithSize:14 isBold:NO]}];
    self.websiteTextView.attributedText=websiteLink;
    
    
    self.websiteTextView.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:74/255.0 green:144/255.0 blue:226/255.0 alpha:1.0]};
    if(!castMemeber.homepageUrlPath || [castMemeber.homepageUrlPath length]==0){
        self.websiteTextView.text=NotFoundText;
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
- (IBAction)didTapSeeFullBioButton:(UIButton *)sender {
    
    if(sender.tag==ButtonStateNormal){
        [sender setTitle:HideBiographyText forState:UIControlStateNormal];
        [sender setTitle:HideBiographyText forState:UIControlStateSelected];
        self.biographyLabel.numberOfLines=0;
        sender.tag=ButtonStateClicked;
    }
    else{
        [sender setTitle:SeeFullBiographyText forState:UIControlStateNormal];
        [sender setTitle:SeeFullBiographyText forState:UIControlStateSelected];
        self.biographyLabel.numberOfLines=7;
        sender.tag=ButtonStateNormal;

    }
    [_delegate setNeedsReload];
}

@end
