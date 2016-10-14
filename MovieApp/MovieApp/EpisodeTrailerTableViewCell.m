#import "EpisodeTrailerTableViewCell.h"

@implementation EpisodeTrailerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

+(NSString *)cellIdentifier{
    return [self cellIClassName];
}

+(NSString *)cellIClassName{
    return @"EpisodeTrailerTableViewCell";
}

-(void)setupWithVideo:(Video *)video{
    [self.videoPlayer loadWithVideoId:video.key];
}

@end
