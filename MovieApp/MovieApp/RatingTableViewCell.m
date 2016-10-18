#import "RatingTableViewCell.h"

#define FONT_SIZE_14 14
#define FONT_SIZE_10 10

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
    
    if(rating<0.1){
        self.ratingLabel.text=@"Not rated";
    }
    else{
        NSMutableAttributedString *content=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.1f/10", rating]];
        
        [content addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:216 green:216 blue:216 alpha:100],
                                 NSFontAttributeName:[MovieAppConfiguration getPreferredFontWithSize:FONT_SIZE_14 isBold:NO]} range:NSMakeRange(0, 3)];
        [content addAttributes:@{NSForegroundColorAttributeName:[MovieAppConfiguration getPrefferedGreyColor],
                                 NSFontAttributeName:[MovieAppConfiguration getPreferredFontWithSize:FONT_SIZE_10 isBold:NO]} range:NSMakeRange(3, 3)];
        
        self.ratingLabel.attributedText=content;
    }
       
}

@end
