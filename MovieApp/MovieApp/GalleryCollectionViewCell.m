#import "GalleryCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DatabaseManager.h"

@implementation GalleryCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)setupWithImageUrl:(NSString *)imageUrl{
    NSString *imageFullUrlPath=[BaseImageUrlForWidth92 stringByAppendingString:imageUrl];
    UIImage *image=[[DatabaseManager sharedDatabaseManager] getUIImageFromImageDbWithID:imageFullUrlPath];
    if(image){
        self.posterImageView.image=image;
    }
    else if([MovieAppConfiguration isConnectedToInternet]){
        [self.posterImageView sd_setImageWithURL:[NSURL URLWithString:imageFullUrlPath] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [[DatabaseManager sharedDatabaseManager] addUIImage:image toImageDbWithID:imageFullUrlPath ];
        }];

    }
}

        

@end
