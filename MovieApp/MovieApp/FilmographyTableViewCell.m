
#import "FilmographyTableViewCell.h"
#import "TVEventCredit.h"
#import <SDWebImage/UIImageView+WebCache.h>

static NSString * const PosterPlaceholderImageName=@"poster-placeholder60x90";
static NSString * const MovieMediaType=@"movie";

@implementation FilmographyTableViewCell
id<ShowDetailsDelegate> _delegateForSegue;
- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setupWithTVEventCredits:(NSArray *)credits delegateForSegue:(id<ShowDetailsDelegate>)delegate{
    _delegateForSegue=delegate;
    for(int i=0;i<[credits count] && i<[self.stackView.subviews count];i++){
        UIStackView *currentStackView=(UIStackView *)self.stackView.subviews[i];
        TVEventCredit *currentCredit=credits[i];
        UIImageView *posterImageView=(UIImageView *)currentStackView.subviews[0];
        UITapGestureRecognizer *singleTapRecogniser=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
        singleTapRecogniser.numberOfTapsRequired=1;
        //tag will be used to identify exact credit
        [posterImageView setTag:i];
        [posterImageView setUserInteractionEnabled:YES];
        [posterImageView addGestureRecognizer:singleTapRecogniser];
        if(currentCredit.posterPath){
            [posterImageView sd_setImageWithURL:[NSURL URLWithString:[BaseImageUrlForWidth92 stringByAppendingString:currentCredit.posterPath]] placeholderImage:[UIImage imageNamed:PosterPlaceholderImageName]];
        }
        UILabel *titleLabel=(UILabel *)currentStackView.subviews[1];
        NSString *tvEventTitle=([currentCredit.mediaType isEqualToString:MovieMediaType]) ? currentCredit.title : currentCredit.name;
        NSMutableAttributedString *tvEventCreditDescription=[[NSMutableAttributedString alloc]initWithString:tvEventTitle attributes:@{NSForegroundColorAttributeName:[MovieAppConfiguration getPrefferedGreyColor]}];
        NSAttributedString *role=[[NSAttributedString alloc] initWithString:currentCredit.character attributes:@{NSForegroundColorAttributeName:[MovieAppConfiguration getPrefferedLightGreyColor]}];
        [tvEventCreditDescription appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
        [tvEventCreditDescription appendAttributedString:role];
        titleLabel.attributedText=tvEventCreditDescription;
        
    }
}

-(void)imageTapped:(UIGestureRecognizer *)sender{
   // [_delegateForSegue showTvEventDetailsForTvEventAtRow:sender.view.tag];
    //in order to make this happen, some changes are needed in TvEventDetailsViewController
}
+(NSString *)cellClassName{
    return @"FilmographyTableViewCell";
}
+(NSString *)cellIdentifier{
    return  [self cellClassName];
}
@end
