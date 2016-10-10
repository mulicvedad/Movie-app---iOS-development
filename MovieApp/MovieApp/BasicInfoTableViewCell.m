#import "BasicInfoTableViewCell.h"

#define HELVETICA_FONT @"HelveticaNeue"
#define FONT_SIZE_REGULAR 10

@implementation BasicInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureView];
}

-(void)configureView{
    self.genresLabel.font=[UIFont fontWithName:HELVETICA_FONT size:FONT_SIZE_REGULAR];
    self.durationLabel.font=[UIFont fontWithName:HELVETICA_FONT size:FONT_SIZE_REGULAR];
    self.releaseDateLabel.font=[UIFont fontWithName:HELVETICA_FONT size:FONT_SIZE_REGULAR];
}


+(NSString *)cellIdentifier{
    return [self cellIClassName];
}
+(NSString *)cellIClassName{
    return @"BasicInfoTableViewCell";
}

-(void)setupWithReleaseDate:(NSString *)dateString duration:(NSUInteger)duration genres:(NSString *)genresRepresentation{
    self.durationLabel.text=[NSString stringWithFormat:@"%dh %dmin", (int)(duration/60),(int)duration%60];
    self.genresLabel.text=genresRepresentation;    
    self.releaseDateLabel.text=dateString;
}

@end
