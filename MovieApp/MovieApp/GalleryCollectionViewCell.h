#import <UIKit/UIKit.h>

@interface GalleryCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
-(void)setupWithImageUrl:(NSString *)imageUrl;
@end
