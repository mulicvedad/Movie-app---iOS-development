#import "EpisodeTableViewCell.h"

@implementation EpisodeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle=UITableViewCellSelectionStyleDefault;
}

-(void)setupWithEpisodeTitle:(NSString *)title airDate:(NSString *)dateAsString rating:(CGFloat)rating ordinalNumber:(NSUInteger)number{
    self.numberLabel.text=[NSString stringWithFormat:@"%d.", (int)number];
    self.episodeTItleLabel.text=title;
    self.ratingLabel.text=[NSString stringWithFormat:@"%.1f", rating];
    self.airDateLabel.text=dateAsString;
}

+(NSString *)cellIdentifier{
    return [self cellIClassName];
}

+(NSString *)cellIClassName{
    return @"EpisodeTableViewCell";
}

@end
