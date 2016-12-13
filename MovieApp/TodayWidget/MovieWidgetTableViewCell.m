#import "MovieWidgetTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation MovieWidgetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    CALayer *bottomBorder = [CALayer layer];
    
    bottomBorder.frame = CGRectMake(0.0f, self.contentView.frame.size.height-1, self.contentView.frame.size.width, 1.0f);
    
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                     alpha:1.0f].CGColor;
    
    [self.contentView.layer addSublayer:bottomBorder];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setupWithTVEvent:(TVEvent *)tvEvent{
    if(tvEvent.title){
        self.titleLabel.text=tvEvent.title;
    }
    else{
        self.titleLabel.text=@"Title not found";
    }
    
    self.ratingLabel.text=[NSString stringWithFormat:@"%.1f", tvEvent.voteAverage];
}
@end
