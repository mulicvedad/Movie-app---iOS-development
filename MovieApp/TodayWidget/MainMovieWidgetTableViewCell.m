#import "MainMovieWidgetTableViewCell.h"

@implementation MainMovieWidgetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
-(void)setupWithTVEvent:(TVEvent *)tvEvent{
    if(tvEvent.posterPath){
        //get image
    }
    
    self.titleLabel.text=tvEvent.title;
    self.ratingLabel.text=[NSString stringWithFormat:@"%.1f",tvEvent.voteAverage];
}

@end
