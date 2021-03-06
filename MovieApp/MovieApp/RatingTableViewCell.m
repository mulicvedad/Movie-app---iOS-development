#import "RatingTableViewCell.h"

#define FontSize14 14
#define FontSize10 10
#define FontSize16 16

@interface  RatingTableViewCell (){
    id _delegate;
}

@end
static NSString * const NotRatedText=@"Not rated";

@implementation RatingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

+(NSString *)cellIdentifier{
    return [self cellIClassName];
}


+(NSString *)cellIClassName{
    return @"RatingTableViewCell";
}

-(void)setupWithRating:(CGFloat)rating delegate:(id<AddTVEventToCollectionDelegate>)delegate{
    UITapGestureRecognizer *tapGestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:delegate action:@selector(didSelectRateThisTVEvent)];
    [self.rateThisLabel addGestureRecognizer:tapGestureRecognizer];
    NSAttributedString *separatorString=[[NSAttributedString alloc] initWithString:@"" attributes:@{NSFontAttributeName:[MovieAppConfiguration getPreferredFontWithSize:FontSize16 isBold:NO], NSForegroundColorAttributeName:[MovieAppConfiguration getPrefferedGreyColor]}];
    NSMutableAttributedString *content=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.1f/10", rating]];
    if(rating<0.1){
        self.ratingLabel.text=NotRatedText;
    }
    else if(rating==10.0f){
        [content addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:216 green:216 blue:216 alpha:100],
                                 NSFontAttributeName:[MovieAppConfiguration getPreferredFontWithSize:FontSize14 isBold:NO]} range:NSMakeRange(0, 4)];
        [content addAttributes:@{NSForegroundColorAttributeName:[MovieAppConfiguration getPrefferedGreyColor],
                                 NSFontAttributeName:[MovieAppConfiguration getPreferredFontWithSize:FontSize10 isBold:NO]} range:NSMakeRange(4, 3)];
        
        [content appendAttributedString:separatorString];
        
        self.ratingLabel.attributedText=content;
    }
    else{
        
        
        [content addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:216 green:216 blue:216 alpha:100],
                                 NSFontAttributeName:[MovieAppConfiguration getPreferredFontWithSize:FontSize14 isBold:NO]} range:NSMakeRange(0, 3)];
        [content addAttributes:@{NSForegroundColorAttributeName:[MovieAppConfiguration getPrefferedGreyColor],
                                 NSFontAttributeName:[MovieAppConfiguration getPreferredFontWithSize:FontSize10 isBold:NO]} range:NSMakeRange(3, 3)];
        
        [content appendAttributedString:separatorString];
        
        self.ratingLabel.attributedText=content;
    }
       
}
-(void)hideRating{
    self.rateThisLabel.hidden=YES;
}

@end
