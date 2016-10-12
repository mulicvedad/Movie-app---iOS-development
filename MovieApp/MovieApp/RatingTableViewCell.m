#import "RatingTableViewCell.h"

#define HELVETICA_FONT @"HelveticaNeue"
#define FONT_SIZE_REGULAR 14
#define FONT_SIZE_SMALL 10

@implementation RatingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(NSString *)cellIdentifier{
    return [self cellIClassName];
}


+(NSString *)cellIClassName{
    return @"RatingTableViewCell";
}

-(void)setupWithRating:(CGFloat)rating{
    NSMutableAttributedString *content=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.1f/10", rating]];
    
    [content addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:216 green:216 blue:216 alpha:100],
                             NSFontAttributeName:[UIFont fontWithName:HELVETICA_FONT size:FONT_SIZE_REGULAR]}range:NSMakeRange(0, 3)];
    [content addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:137 green:136 blue:133 alpha:100],
                             NSFontAttributeName:[UIFont fontWithName:HELVETICA_FONT size:FONT_SIZE_SMALL]}range:NSMakeRange(3, 3)];
    
    self.ratingLabel.attributedText=content;
    
}

@end
