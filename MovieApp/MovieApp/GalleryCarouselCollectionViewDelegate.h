#import <Foundation/Foundation.h>
#import "CarouselCollectionViewCell.h"
#import "GallerySelectionHandler.h"

@interface GalleryCarouselCollectionViewDelegate : NSObject <UICollectionViewDelegate, UICollectionViewDataSource>
-(void)setupWithImages:(NSArray *)images selectionHandler:(id<GallerySelectionHandler>)selectionHandler;
@end
