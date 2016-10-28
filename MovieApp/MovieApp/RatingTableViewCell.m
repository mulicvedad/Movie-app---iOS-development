#import "RatingTableViewCell.h"

#define FontSize14 14
#define FontSize10 10

static NSString * const NotRatedText=@"Not rated";

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
        self.ratingLabel.text=NotRatedText;
    }
    else{
        NSMutableAttributedString *content=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.1f/10", rating]];
        
        [content addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:216 green:216 blue:216 alpha:100],
                                 NSFontAttributeName:[MovieAppConfiguration getPreferredFontWithSize:FontSize14 isBold:NO]} range:NSMakeRange(0, 3)];
        [content addAttributes:@{NSForegroundColorAttributeName:[MovieAppConfiguration getPrefferedGreyColor],
                                 NSFontAttributeName:[MovieAppConfiguration getPreferredFontWithSize:FontSize10 isBold:NO]} range:NSMakeRange(3, 3)];
        
        self.ratingLabel.attributedText=content;
    }
       
}

@end
