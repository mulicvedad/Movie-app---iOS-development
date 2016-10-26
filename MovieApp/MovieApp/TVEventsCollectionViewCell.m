#import "TVEventsCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Movie.h"
#import "TVShow.h"
#import "TheMovieDBConstants.h"

#define FontSize10 10
#define FontSize16 16

@interface TVEventsCollectionViewCell(){
    CAGradientLayer *_myGradientLayer;
}

@end

static NSString * const MovieDateFormat=@"dd MMMM yyyy";
static NSString * const TVshowDateFormat=@"yyyy";
static NSString * const DefaultImageName=@"black_image";
static NSString * const PlaceholderImageName=@"poster-placeholder";
static NSString * const TVShowReleaseDatePrefix=@"Tv Series ";
static CGFloat const StartPointX=0.5f;
static CGFloat const StartPointY=0.25f;
static CGFloat const EndPointX=0.5f;
static CGFloat const EndPointY=0.75f;


@implementation TVEventsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _myGradientLayer=[[CAGradientLayer alloc]init];
    
    _myGradientLayer.frame = self.frame;
    _myGradientLayer.startPoint = CGPointMake(StartPointX,StartPointY);
    _myGradientLayer.endPoint = CGPointMake(EndPointX, EndPointY);
    _myGradientLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor],
                               (id)[[UIColor blackColor] CGColor],
                               nil];
    [self.viewForGradient.layer insertSublayer:_myGradientLayer atIndex:0];
    [self.titleLabel setFont:[MovieAppConfiguration getPreferredFontWithSize:FontSize16 isBold:YES]];
    [self.ratingLabel setFont:[MovieAppConfiguration getPreferredFontWithSize:FontSize10 isBold:NO]];
    [self.releaseDateLabel setFont:[MovieAppConfiguration getPreferredFontWithSize:FontSize16 isBold:NO]];
    [self.genreLabel setFont:[MovieAppConfiguration getPreferredFontWithSize:FontSize10 isBold:NO]];
}

+(UIEdgeInsets)cellInsets{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

+(CGFloat)cellHeight{
    return 254;
}

+(NSString *)cellIdentifier{
    return [self cellViewClassName];
}

+(NSString *)cellViewClassName{
    return @"TVEventsCollectionViewCell";
    
}

-(void)setupWithTvEvent:(TVEvent *)tvEvent{
    BOOL isMovie=([tvEvent isKindOfClass:[Movie class]]) ? YES : NO;
    
    self.titleLabel.text=[tvEvent.title uppercaseString];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    NSString *dateString;
    [dateFormatter setDateFormat:isMovie ? MovieDateFormat : TVshowDateFormat];
    if(isMovie){
        dateString=[dateFormatter stringFromDate:tvEvent.releaseDate];
    }
    else{
        dateString=[[TVShowReleaseDatePrefix stringByAppendingString:[dateFormatter stringFromDate:tvEvent.releaseDate]] stringByAppendingString:@" -"];
    }
    self.releaseDateLabel.text=dateString;
    
    NSString *genresRepresentation=EmptyString;
    NSUInteger numberOfGenres=[tvEvent.genreIDs count];
    for(int i=0;i<numberOfGenres;i++){
        NSUInteger genreID=[(NSNumber *)tvEvent.genreIDs[i] unsignedIntegerValue];
        NSString *genreName=[tvEvent getGenreNameForId:genreID];
        
        if(i==numberOfGenres-1){
            genresRepresentation=[genresRepresentation stringByAppendingString:genreName];
        }
        else{
            genresRepresentation=[genresRepresentation stringByAppendingString:genreName ];
            genresRepresentation=[genresRepresentation  stringByAppendingString:@", "];
        }
    }
    
    self.genreLabel.text =  genresRepresentation;
    self.ratingLabel.text=[NSString stringWithFormat:@"%.1f", tvEvent.voteAverage];
    if(tvEvent.posterPath){

        [self.posterImageView sd_setImageWithURL:[NSURL URLWithString:[BaseImageUrlForWidth185 stringByAppendingString:tvEvent.posterPath]] placeholderImage:[UIImage  imageNamed:PlaceholderImageName]];
    }
    else{
        self.posterImageView.image=[UIImage imageNamed:DefaultImageName];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _myGradientLayer.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height);
}


@end
