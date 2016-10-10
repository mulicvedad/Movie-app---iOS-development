#import "TrailerTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define START_POINT_X 0.5
#define START_POINT_Y 0.5
#define END_POINT_X 0.5
#define END_POINT_Y 1.0
#define HEIGHT_WIDTH_RATIO 1.689
#define YEAR_FORMAT @"yyyy"
#define HELVETICA_FONT @"HelveticaNeue"
#define HELVETICA_FONT_BOLD @"HelveticaNeue-Bold"
#define FONT_SIZE_REGULAR 10
#define FONT_SIZE_BIG 16


@implementation TrailerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.titleLabel setFont:[UIFont fontWithName:HELVETICA_FONT_BOLD size:FONT_SIZE_BIG]];
    [self setGradientLayer];
}
-(void)setupCellWithTitle:(NSString *)originalTitle imageUrl:(NSURL *)imageUrl releaseYear:(NSString *)releaseYear{
    [self.trailerImageView sd_setImageWithURL:imageUrl];

    _titleLabel.text=[[[[originalTitle stringByAppendingString:@" ("]stringByAppendingString:releaseYear]stringByAppendingString:@")"] uppercaseString];

}

-(void)setGradientLayer{
    CAGradientLayer *_myGradientLayer=[[CAGradientLayer alloc]init];

    _myGradientLayer.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.width/HEIGHT_WIDTH_RATIO);
    
    _myGradientLayer.startPoint = CGPointMake(START_POINT_X,START_POINT_Y);
    _myGradientLayer.endPoint = CGPointMake(END_POINT_X, END_POINT_Y);
    _myGradientLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor],
                               (id)[[UIColor blackColor] CGColor],
                               (id)[[UIColor blackColor] CGColor],
                               nil];
    [self.viewForGradient.layer addSublayer:_myGradientLayer];
}


+(NSString *)cellIdentifier{
    return [TrailerTableViewCell cellIClassName];
}
+(NSString *)cellIClassName{
    return @"TrailerTableViewCell";
}

@end
