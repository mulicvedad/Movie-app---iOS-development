#import "ImagesTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "TVEventDetailsTableViewController.h"

@interface ImagesTableViewCell (){
    id _galleryDelegate;
}
@end

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

-(void)setupWithUrls:(NSArray *)urls delegate:(id)delegate{
    _galleryDelegate=delegate;
    for(int i=0;i<[urls count] && i<[_posterImageViews count]; i++ ){
        [_posterImageViews[i] sd_setImageWithURL:(NSURL *)urls[i] placeholderImage:[UIImage imageNamed:PosterPlaceholderImageName]];
    }
}
- (IBAction)openGallery:(UIButton *)sender {
    if(_galleryDelegate){
        if([_galleryDelegate respondsToSelector:@selector(openGallery)]){
            [_galleryDelegate openGallery];
        }
    }
}

@end
