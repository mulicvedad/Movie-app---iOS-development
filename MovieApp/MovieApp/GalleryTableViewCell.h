#import <UIKit/UIKit.h>
#import "GallerySelectionHandler.h"

@interface GalleryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *galleryCollectionView;
@property (nonatomic, strong) id<GallerySelectionHandler> selectionHandler;
@end
