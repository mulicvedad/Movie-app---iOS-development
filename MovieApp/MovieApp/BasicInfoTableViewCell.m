#import "BasicInfoTableViewCell.h"

#define FontSize10 10

static NSString * const UnknownDurationText=@"Unknown duration";

@implementation BasicInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureView];
}

-(void)configureView{
    UIFont *preferredFont=[MovieAppConfiguration getPreferredFontWithSize:FontSize10 isBold:NO];
    self.genresLabel.font=preferredFont;
    self.durationLabel.font=preferredFont;
    self.releaseDateLabel.font=preferredFont;
}

+(NSString *)cellIdentifier{
    return [self cellIClassName];
}
+(NSString *)cellIClassName{
    return @"BasicInfoTableViewCell";
}

-(void)setupWithReleaseDate:(NSString *)dateString duration:(NSUInteger)duration genres:(NSString *)genresRepresentation{
    if(duration==0){
        self.durationLabel.text=UnknownDurationText;
    }
    else{
        self.durationLabel.text=[NSString stringWithFormat:@"%dh %dmin", (int)(duration/60),(int)duration%60];
    }
    self.genresLabel.text=genresRepresentation;
    self.releaseDateLabel.text=dateString;
}

-(void)setupWithTVEvent:(TVEvent *)tvEvent{
    if(tvEvent.duration==0){
        self.durationLabel.text=UnknownDurationText;
    }
    else{
        self.durationLabel.text=[NSString stringWithFormat:@"%dh %dmin", (int)(tvEvent.duration/60),(int)tvEvent.duration%60];
    }
    self.genresLabel.text=[tvEvent getFormattedGenresRepresentation];
    self.releaseDateLabel.text=[tvEvent getFormattedReleaseDate];
}


@end
