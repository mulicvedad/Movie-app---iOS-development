#import "GalleryCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation GalleryCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)setupWithImageUrl:(NSString *)imageUrl{
    
    [self.posterImageView sd_setImageWithURL:[NSURL URLWithString:[BaseImageUrlForWidth92 stringByAppendingString:imageUrl]]];
}

@end
