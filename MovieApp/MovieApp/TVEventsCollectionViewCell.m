#import "TVEventsCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Movie.h"
#import "TVShow.h"

#define START_POINT_X 0.5
#define START_POINT_Y 0.25
#define END_POINT_X 0.5
#define END_POINT_Y 0.75
#define MOVIE_DATE_FORMAT @"dd MMMM yyyy"
#define TVSHOW_DATE_FORMAT @"yyyy"
#define BASE_IMAGE_URL @"http://image.tmdb.org/t/p/w185"
#define HELVETICA_FONT @"HelveticaNeue"
#define HELVETICA_FONT_BOLD @"HelveticaNeue-Bold"
#define FONT_SIZE_REGULAR 10
#define FONT_SIZE_BIG 16
#define DEFAULT_IMAGE_NAME @"black_image"


@implementation TVEventsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    CAGradientLayer *_myGradientLayer=[[CAGradientLayer alloc]init];
    
    _myGradientLayer.frame = self.frame;
    _myGradientLayer.startPoint = CGPointMake(START_POINT_X,START_POINT_Y);
    _myGradientLayer.endPoint = CGPointMake(END_POINT_X, END_POINT_Y);
    _myGradientLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor],
                               (id)[[UIColor blackColor] CGColor],
                               nil];
    [self.viewForGradient.layer insertSublayer:_myGradientLayer atIndex:0];
    [self.titleLabel setFont:[UIFont fontWithName:HELVETICA_FONT_BOLD size:FONT_SIZE_BIG]];
    [self.ratingLabel setFont:[UIFont fontWithName:HELVETICA_FONT size:FONT_SIZE_REGULAR]];
    [self.releaseDateLabel setFont:[UIFont fontWithName:HELVETICA_FONT size:FONT_SIZE_REGULAR]];
    [self.genreLabel setFont:[UIFont fontWithName:HELVETICA_FONT size:FONT_SIZE_REGULAR]];
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
    [dateFormatter setDateFormat:isMovie ? MOVIE_DATE_FORMAT : TVSHOW_DATE_FORMAT];
    if(isMovie){
        dateString=[dateFormatter stringFromDate:tvEvent.releaseDate];
    }
    else{
        dateString=[[@"Tv Series " stringByAppendingString:[dateFormatter stringFromDate:tvEvent.releaseDate]] stringByAppendingString:@" -"];
    }
    self.releaseDateLabel.text=dateString;
    
    NSString *genresRepresentation=@"";
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
        [self.posterImageView sd_setImageWithURL:[NSURL URLWithString:[BASE_IMAGE_URL stringByAppendingString:tvEvent.posterPath]]];
    }
    else{
        self.posterImageView.image=[UIImage imageNamed:DEFAULT_IMAGE_NAME];
    }
}


@end
