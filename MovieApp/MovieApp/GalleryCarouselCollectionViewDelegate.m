#import "GalleryCarouselCollectionViewDelegate.h"
#import "Image.h"
#import "GalleryCollectionViewCell.h"

@interface  GalleryCarouselCollectionViewDelegate (){
    NSArray *_images;
    id<GallerySelectionHandler> _delegate;
}

@end

@implementation GalleryCarouselCollectionViewDelegate

-(void)setupWithImages:(NSArray *)images selectionHandler:(id<GallerySelectionHandler>)selectionHandler{
    _images=images;
    _delegate=selectionHandler;
    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_images count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GalleryCollectionViewCell *carouselCell=[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([GalleryCollectionViewCell class])  forIndexPath:indexPath];
    Image *currentImage=_images[indexPath.row];
    
    [carouselCell setupWithImageUrl:currentImage.filePath];
    return carouselCell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(92, 138);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout{
    
    return  UIEdgeInsetsMake(2, 0, 2, 10);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(_delegate){
        [_delegate didSelectImageWIthIndex:indexPath.row];
    }
}




@end
