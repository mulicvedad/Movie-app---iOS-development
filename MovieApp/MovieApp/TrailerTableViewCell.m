#import "TrailerTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define FontSize18 18
#define FontSize12 12
static NSString * const YearDateFormat=@"yyyy";
static NSString * const WideImagePlaceholder=@"yyyy";
static CGFloat const DefaultHeightWidthRatio=1.689;
static CGFloat const StartPointX=0.5;
static CGFloat const StartPointY=0.5;
static CGFloat const EndPointX=0.5;
static CGFloat const EndPointY=1.0;


@interface TrailerTableViewCell(){
    id<ShowTrailerDelegate> _delegate;
}

@end

@implementation TrailerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setGradientLayer];
}
-(void)setupCellWithTitle:(NSString *)originalTitle imageUrl:(NSURL *)imageUrl releaseYear:(NSString *)releaseYear{
    releaseYear=(releaseYear) ? releaseYear : @"Year not found";
    originalTitle=(originalTitle) ? originalTitle : @"Title not found";
    if(imageUrl){
        [self.trailerImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:WideImagePlaceholder]];
    }
    else{
        self.trailerImageView.image=[UIImage imageNamed:WideImagePlaceholder];
    }
    
    NSMutableAttributedString *titleAttributedString=[[NSMutableAttributedString alloc] initWithString:originalTitle attributes:@{NSFontAttributeName:[MovieAppConfiguration getPreferredFontWithSize:FontSize18 isBold:YES], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    NSMutableAttributedString *yearAttributedString=[[NSMutableAttributedString alloc] initWithString:
                                                     [[@" (" stringByAppendingString:releaseYear] stringByAppendingString:@")" ] attributes:@{NSFontAttributeName:[MovieAppConfiguration getPreferredFontWithSize:FontSize12 isBold:NO], NSForegroundColorAttributeName:[MovieAppConfiguration getPrefferedGreyColor]}];

    [titleAttributedString appendAttributedString:yearAttributedString];
    self.titleLabel.attributedText=titleAttributedString;
    

}

-(void)setupWithTVEvent:(TVEvent *)tvEvent{
    NSURL *imageUrl=nil;
    if(tvEvent.backdropPath){
        imageUrl=[NSURL URLWithString:[BaseImageUrlForWidth500 stringByAppendingString:tvEvent.backdropPath ]];
    }
    [self.trailerImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:WideImagePlaceholder]];
    NSString *releaseYear;
    NSString *originalTitle;
    releaseYear=([tvEvent getReleaseYear]) ? [tvEvent getReleaseYear] : @"Year not found";
    originalTitle=(tvEvent.originalTitle) ? tvEvent.originalTitle : @"Title not found";
    
    NSMutableAttributedString *titleAttributedString=[[NSMutableAttributedString alloc] initWithString:originalTitle attributes:@{NSFontAttributeName:[MovieAppConfiguration getPreferredFontWithSize:FontSize18 isBold:YES], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    NSMutableAttributedString *yearAttributedString=[[NSMutableAttributedString alloc] initWithString:
                                                     [[@" (" stringByAppendingString:releaseYear] stringByAppendingString:@")" ] attributes:@{NSFontAttributeName:[MovieAppConfiguration getPreferredFontWithSize:FontSize12 isBold:NO], NSForegroundColorAttributeName:[MovieAppConfiguration getPrefferedGreyColor]}];
    
    [titleAttributedString appendAttributedString:yearAttributedString];
    self.titleLabel.attributedText=titleAttributedString;

}

-(void)setGradientLayer{
    _myGradientLayer=[[CAGradientLayer alloc]init];

    _myGradientLayer.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.width/DefaultHeightWidthRatio);
    
    _myGradientLayer.startPoint = CGPointMake(StartPointX,StartPointY);
    _myGradientLayer.endPoint = CGPointMake(EndPointX, EndPointY);
    _myGradientLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor],
                               (id)[[UIColor blackColor] CGColor],
                               (id)[[UIColor blackColor] CGColor],
                               nil];
    [self.viewForGradient.layer addSublayer:_myGradientLayer];
    self.viewForGradient.layer.masksToBounds = YES;

}

-(void)layoutSubviews{
    [super layoutSubviews];
    _myGradientLayer.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.width/DefaultHeightWidthRatio);
}

+(NSString *)cellIdentifier{
    return [TrailerTableViewCell cellIClassName];
}
+(NSString *)cellIClassName{
    return @"TrailerTableViewCell";
}

-(void)setDelegate:(id<ShowTrailerDelegate>)delegate{
    _delegate=delegate;
}
- (IBAction)showTrailer:(UIButton *)sender {
    [_delegate showTrailer];
}

@end
