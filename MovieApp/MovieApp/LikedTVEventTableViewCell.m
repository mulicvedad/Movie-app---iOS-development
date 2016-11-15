#import "LikedTVEventTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

static NSString * const PosterPlaceholderImageName=@"poster-placeholder";
static NSString * const NameNotFoundText=@"Name not found";
static NSString * const DateNotFoundText=@"Date not found";


@implementation LikedTVEventTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
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
    NSString *dateString=(tvEvent.releaseDate==nil) ? DateNotFoundText : [tvEvent getReleaseYear];
    
    self.titleLabel.text=title;
    self.yearLabel.text=dateString;
    self.ratingLabel.text=[NSString  stringWithFormat:@"%.1f", tvEvent.voteAverage];
}
@end
