#import "GalleryTableViewCell.h"

@implementation GalleryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (IBAction)openGallery:(UIButton *)sender {
    [self.selectionHandler openGallery];
}

@end
