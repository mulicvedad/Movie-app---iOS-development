#import "SearchResultItemTableViewCell.h"
#import "MovieAppConfiguration.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Movie.h"
#import "TVShow.h"

#define PLACEHOLDER_IMAGE_NAME @"poster-placeholder"
#define FONT_SIZE_12 12
#define FONT_SIZE_18 18
#define FILLED_STAR_CODE @"\u2605 "
#define BASE_POSTERIMAGE_URL @"http://image.tmdb.org/t/p/w92"

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
    
    NSMutableAttributedString *starString=[[NSMutableAttributedString alloc]initWithString:FILLED_STAR_CODE attributes:@{NSForegroundColorAttributeName:[MovieAppConfiguration getPrefferedYellowColor],NSFontAttributeName:[MovieAppConfiguration getPreferredFontWithSize:FONT_SIZE_12 isBold:NO]}];
    
    NSAttributedString *ratingString=[[NSMutableAttributedString alloc]initWithString:[NSString  stringWithFormat:@"%.1f", voteAverage] attributes:@{NSForegroundColorAttributeName:[MovieAppConfiguration getPrefferedGreyColor],NSFontAttributeName:[MovieAppConfiguration getPreferredFontWithSize:FONT_SIZE_12 isBold:NO]}];
    [starString appendAttributedString:ratingString];
    
    self.ratingLabel.attributedText=starString;
    
}
-(void)setupWithTvEvent:(TVEvent *)tvEvent{
    NSURL *imageUrl;
    if(tvEvent.posterPath){
        imageUrl=[NSURL URLWithString:[BASE_POSTERIMAGE_URL stringByAppendingString:tvEvent.posterPath]];
        [self.posterImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:PLACEHOLDER_IMAGE_NAME]];

    }
    else{
        self.posterImageView.image=[UIImage imageNamed:PLACEHOLDER_IMAGE_NAME];
    }
    NSString *title=(tvEvent.title==nil) ? @"Name not found" : tvEvent.title;
    
    NSMutableAttributedString *titleAttributedString=[[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:[MovieAppConfiguration getPreferredFontWithSize:FONT_SIZE_18 isBold:NO], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    NSMutableAttributedString *dateAttributedString;
    
    if(!tvEvent.releaseDate){
        dateAttributedString=[[NSMutableAttributedString alloc] initWithString:@""];
    }
    else{
        dateAttributedString=[[NSMutableAttributedString alloc] initWithString:
                              [[@" (" stringByAppendingString:[tvEvent isKindOfClass:[Movie class]] ? [tvEvent getReleaseYear] : [(TVShow *)tvEvent getFormattedReleaseDate]]
                               stringByAppendingString:@")" ] attributes:@{NSFontAttributeName:[MovieAppConfiguration getPreferredFontWithSize:FONT_SIZE_12 isBold:NO], NSForegroundColorAttributeName:[MovieAppConfiguration getPrefferedGreyColor]}];
    }
    
    if(![tvEvent isKindOfClass:[Movie class]] && tvEvent.releaseDate){
        [titleAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
    }
    [titleAttributedString appendAttributedString:dateAttributedString];
    
    self.titleLabel.attributedText=titleAttributedString;
    
    NSMutableAttributedString *starString=[[NSMutableAttributedString alloc]initWithString:FILLED_STAR_CODE attributes:@{NSForegroundColorAttributeName:[MovieAppConfiguration getPrefferedYellowColor],NSFontAttributeName:[MovieAppConfiguration getPreferredFontWithSize:FONT_SIZE_12 isBold:NO]}];
    
    NSAttributedString *ratingString=[[NSMutableAttributedString alloc]initWithString:[NSString  stringWithFormat:@"%.1f", tvEvent.voteAverage] attributes:@{NSForegroundColorAttributeName:[MovieAppConfiguration getPrefferedGreyColor],NSFontAttributeName:[MovieAppConfiguration getPreferredFontWithSize:FONT_SIZE_12 isBold:NO]}];
    [starString appendAttributedString:ratingString];
    
    self.ratingLabel.attributedText=starString;
}

- (IBAction)showDetails:(UIButton *)sender {
    [_delegate showTvEventDetailsForTvEventAtRow:_rowIndex];
}

@end
