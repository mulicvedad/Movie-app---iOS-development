#import "SearchResultItemTableViewCell.h"
#import "MovieAppConfiguration.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Movie.h"
#import "TVShow.h"

#define FontSize12 12
#define FontSize18 18
static NSString * const PosterPlaceholderImageName=@"poster-placeholder-new-medium";
static NSString * const NameNotFoundText=@"Name not found";


@interface SearchResultItemTableViewCell(){
    id<ShowDetailsDelegate> _delegate;
    NSUInteger _rowIndex;
}

@end

@implementation SearchResultItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
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
-(void)configureForLikedTVEvents{
    self.contentView.backgroundColor=[UIColor blackColor];
    self.lineView.backgroundColor=[UIColor colorWithRed:42/255.0 green:45/255.0 blue:44/255.0 alpha:1.0];
    self.arrowButtob.hidden=YES;

}
-(void)setupWithTitle:(NSAttributedString *)title rating:(float)voteAverage imageUrl:(NSURL *)imagePosterUrl{
    if(imagePosterUrl){
        [self.posterImageView sd_setImageWithURL:imagePosterUrl placeholderImage:[UIImage imageNamed:PosterPlaceholderImageName]];
    }
    self.titleLabel.attributedText=title;
    
    NSMutableAttributedString *starString=[[NSMutableAttributedString alloc]initWithString:FilledStarCode attributes:@{NSForegroundColorAttributeName:[MovieAppConfiguration getPrefferedYellowColor],NSFontAttributeName:[MovieAppConfiguration getPreferredFontWithSize:FontSize12 isBold:NO]}];
    
    NSAttributedString *ratingString=[[NSMutableAttributedString alloc]initWithString:[NSString  stringWithFormat:@"%.1f", voteAverage] attributes:@{NSForegroundColorAttributeName:[MovieAppConfiguration getPrefferedGreyColor],NSFontAttributeName:[MovieAppConfiguration getPreferredFontWithSize:FontSize12 isBold:NO]}];
    [starString appendAttributedString:ratingString];
    
    self.ratingLabel.attributedText=starString;
    
}
-(void)setupWithTvEvent:(TVEvent *)tvEvent{
    NSURL *imageUrl;
    if(tvEvent.posterPath){
        imageUrl=[NSURL URLWithString:[BaseImageUrlForWidth92 stringByAppendingString:tvEvent.posterPath]];
        [self.posterImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:PosterPlaceholderImageName]];

    }
    else{
        self.posterImageView.image=[UIImage imageNamed:PosterPlaceholderImageName];
    }
    NSString *title=(tvEvent.title==nil) ? NameNotFoundText : tvEvent.title;
    
    NSMutableAttributedString *titleAttributedString=[[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:[MovieAppConfiguration getPreferredFontWithSize:FontSize18 isBold:NO], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    NSMutableAttributedString *dateAttributedString;
    
    if(!tvEvent.releaseDate){
        dateAttributedString=[[NSMutableAttributedString alloc] initWithString:@""];
    }
    else{
        dateAttributedString=[[NSMutableAttributedString alloc] initWithString:
                              [[@" (" stringByAppendingString:[tvEvent isKindOfClass:[Movie class]] ? [tvEvent getReleaseYear] : [(TVShow *)tvEvent getFormattedReleaseDate]]
                               stringByAppendingString:@")" ] attributes:@{NSFontAttributeName:[MovieAppConfiguration getPreferredFontWithSize:14 isBold:NO], NSForegroundColorAttributeName:[MovieAppConfiguration getPrefferedGreyColor]}];
    }
    
    if(tvEvent.releaseDate){
        [titleAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
    }
    [titleAttributedString appendAttributedString:dateAttributedString];
    
    self.titleLabel.attributedText=titleAttributedString;
    
    NSMutableAttributedString *starString=[[NSMutableAttributedString alloc]initWithString:FilledStarCode attributes:@{NSForegroundColorAttributeName:[MovieAppConfiguration getPrefferedYellowColor],NSFontAttributeName:[MovieAppConfiguration getPreferredFontWithSize:FontSize12 isBold:NO]}];
    
    NSAttributedString *ratingString=[[NSMutableAttributedString alloc]initWithString:[NSString  stringWithFormat:@"%.1f", tvEvent.voteAverage] attributes:@{NSForegroundColorAttributeName:[MovieAppConfiguration getPrefferedGreyColor],NSFontAttributeName:[MovieAppConfiguration getPreferredFontWithSize:FontSize12 isBold:NO]}];
    [starString appendAttributedString:ratingString];
    
    self.ratingLabel.attributedText=starString;
}

- (IBAction)showDetails:(UIButton *)sender {
    [_delegate showTvEventDetailsForTvEventAtRow:_rowIndex];
}

@end
