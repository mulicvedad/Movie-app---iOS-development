#import "CarouselCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Image.h"
#import "DatabaseManager.h"

@implementation CarouselCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

+(NSString *)cellClassName{
    return @"CarouselCollectionViewCell";
}
+(NSString *)cellIdentifier{
    return  [self cellClassName];
}
-(void)setupWithCastMember:(CastMember *)castMember{
    if(castMember.profileImageUrl){
        [self configureImageViewWithImageUrl:[BaseImageUrlForWidth92 stringByAppendingString:castMember.profileImageUrl]];
        //[self.posterImageView sd_setImageWithURL:[NSURL URLWithString:[BaseImageUrlForWidth92 stringByAppendingString:castMember.profileImageUrl]]];
    }
    self.nameLabel.text=castMember.name;
    self.rolesLabel.text=castMember.character;    
                                             
}

-(void)setupWithTVEvent:(TVEventCredit *)tvEvent castMember:(CastMember *)castMember{
    if(tvEvent.posterPath){
        [self configureImageViewWithImageUrl:[BaseImageUrlForWidth92 stringByAppendingString:tvEvent.posterPath]];
        //[self.posterImageView sd_setImageWithURL:[NSURL URLWithString:[BaseImageUrlForWidth92 stringByAppendingString:tvEvent.posterPath]]];
    }
    self.nameLabel.numberOfLines=3;
    self.nameLabel.text=tvEvent.title;
    self.rolesLabel.text=castMember.character;
    
}

-(void)setupWithImageUrl:(NSString *)imageUrl selectionHandler:(id<GallerySelectionHandler>)selectionHandler{
   
     [self.posterImageView sd_setImageWithURL:[NSURL URLWithString:[BaseImageUrlForWidth92 stringByAppendingString:imageUrl]] placeholderImage:[UIImage imageNamed:@"poster-placeholder-new-medium"]];
    self.nameLabel.text=@"test";
    self.rolesLabel.hidden=YES;
}

-(void)configureImageViewWithImageUrl:(NSString *)imageFullUrlPath{
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
