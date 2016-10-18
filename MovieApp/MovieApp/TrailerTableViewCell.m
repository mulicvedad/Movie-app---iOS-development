#import "TrailerTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define WIDE_IMAGE_PLACEHOLDER @"wide-placeholder"


#define START_POINT_X 0.5
#define START_POINT_Y 0.5
#define END_POINT_X 0.5
#define END_POINT_Y 1.0
#define HEIGHT_WIDTH_RATIO 1.689
#define YEAR_FORMAT @"yyyy"
#define HELVETICA_FONT @"HelveticaNeue"
#define HELVETICA_FONT_BOLD @"HelveticaNeue-Bold"
#define FONT_SIZE_18 18
#define FONT_SIZE_12 12

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
        [self.trailerImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:WIDE_IMAGE_PLACEHOLDER]];
    }
    else{
        self.trailerImageView.image=[UIImage imageNamed:WIDE_IMAGE_PLACEHOLDER];
    }
    
    NSMutableAttributedString *titleAttributedString=[[NSMutableAttributedString alloc] initWithString:originalTitle attributes:@{NSFontAttributeName:[MovieAppConfiguration getPreferredFontWithSize:FONT_SIZE_18 isBold:YES], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    NSMutableAttributedString *yearAttributedString=[[NSMutableAttributedString alloc] initWithString:
                                                     [[@" (" stringByAppendingString:releaseYear] stringByAppendingString:@")" ] attributes:@{NSFontAttributeName:[MovieAppConfiguration getPreferredFontWithSize:FONT_SIZE_12 isBold:NO], NSForegroundColorAttributeName:[MovieAppConfiguration getPrefferedGreyColor]}];

    [titleAttributedString appendAttributedString:yearAttributedString];
    self.titleLabel.attributedText=titleAttributedString;
    

}

-(void)setGradientLayer{
    _myGradientLayer=[[CAGradientLayer alloc]init];

    _myGradientLayer.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.width/HEIGHT_WIDTH_RATIO);
    
    _myGradientLayer.startPoint = CGPointMake(START_POINT_X,START_POINT_Y);
    _myGradientLayer.endPoint = CGPointMake(END_POINT_X, END_POINT_Y);
    _myGradientLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor],
                               (id)[[UIColor blackColor] CGColor],
                               (id)[[UIColor blackColor] CGColor],
                               nil];
    [self.viewForGradient.layer addSublayer:_myGradientLayer];
    self.viewForGradient.layer.masksToBounds = YES;

}

-(void)layoutSubviews{
    [super layoutSubviews];
    _myGradientLayer.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.width/HEIGHT_WIDTH_RATIO);
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
