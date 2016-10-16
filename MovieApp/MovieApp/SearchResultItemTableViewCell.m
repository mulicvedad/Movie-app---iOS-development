#import "SearchResultItemTableViewCell.h"
#import "MovieAppConfiguration.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define PLACEHOLDER_IMAGE_NAME @"poster-placeholder"
#define HELVETICA_FONT @"HelveticaNeue"
#define FONT_SIZE_REGULAR 12
#define FONT_SIZE_BIG 18
#define FILLED_STAR_CODE @"\u2605 "

@interface SearchResultItemTableViewCell(){
    id<ShowDetailsDelegate> _delegate;
    NSUInteger _rowIndex;
}

@end

@implementation SearchResultItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)registerDelegate:(id<ShowDetailsDelegate>)delegate tableViewRowNumber:(NSUInteger)rowIndex{
    _rowIndex=rowIndex;
    _delegate=delegate;
}

+(NSString *)cellIdentifier{
    return [self cellIClassName];
}

+(NSString *)cellIClassName{
    return @"SearchResultItemTableViewCell";
}

-(void)setupWithTitle:(NSAttributedString *)title rating:(float)voteAverage imageUrl:(NSURL *)imagePosterUrl{
    if(imagePosterUrl){
        [self.posterImageView sd_setImageWithURL:imagePosterUrl placeholderImage:[UIImage imageNamed:PLACEHOLDER_IMAGE_NAME]];
    }
    self.titleLabel.attributedText=title;
    
    NSMutableAttributedString *starString=[[NSMutableAttributedString alloc]initWithString:FILLED_STAR_CODE attributes:@{NSForegroundColorAttributeName:[MovieAppConfiguration getPrefferedYellowColor],NSFontAttributeName:[UIFont fontWithName:HELVETICA_FONT size:FONT_SIZE_REGULAR]}];
    
    NSAttributedString *ratingString=[[NSMutableAttributedString alloc]initWithString:[NSString  stringWithFormat:@"%.1f", voteAverage] attributes:@{NSForegroundColorAttributeName:[MovieAppConfiguration getPrefferedGreyColor],NSFontAttributeName:[UIFont fontWithName:HELVETICA_FONT size:FONT_SIZE_REGULAR]}];
    [starString appendAttributedString:ratingString];
    
    self.ratingLabel.attributedText=starString;
    
}

- (IBAction)showDetails:(UIButton *)sender {
    [_delegate showTvEventDetailsForTvEventAtRow:_rowIndex];
}

@end
