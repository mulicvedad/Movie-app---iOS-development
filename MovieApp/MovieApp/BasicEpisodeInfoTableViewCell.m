#import "BasicEpisodeInfoTableViewCell.h"

@implementation BasicEpisodeInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

+(NSString *)cellIdentifier{
    return [self cellIClassName];
}

+(NSString *)cellIClassName{
    return @"BasicEpisodeInfoTableViewCell";
}

-(void)setupWithTitle:(NSString *)title airDate:(NSString *)dateAsString{
    self.titleLabel.text=title;
    self.airDateLabel.text=dateAsString;
}

@end
