#import <Foundation/Foundation.h>

@protocol GallerySelectionHandler <NSObject>
-(void)didSelectImageWIthIndex:(NSInteger)index;
-(void)openGallery;
@end
