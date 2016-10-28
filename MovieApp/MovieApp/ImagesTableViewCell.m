#import "ImagesTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

static NSString * const PosterPlaceholderImageName=@"poster-placeholder";
@implementation ImagesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}


+(NSString *)cellIdentifier{
    return [self cellIClassName];
}

+(NSString *)cellIClassName{
    return @"ImagesTableViewCell";
}

-(void)setupWithUrls:(NSArray *)urls{
    for(int i=0;i<[urls count] && i<[_posterImageViews count]; i++ ){
        [_posterImageViews[i] sd_setImageWithURL:(NSURL *)urls[i] placeholderImage:[UIImage imageNamed:PosterPlaceholderImageName]];
    }
}

@end
