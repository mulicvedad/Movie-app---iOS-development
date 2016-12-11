#import "CastMemberPictureTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DatabaseManager.h"

@interface CastMemberPictureTableViewCell (){
    CAGradientLayer *_myGradientLayer;
}

@end

@implementation CastMemberPictureTableViewCell
static const CGFloat startPointX=0.5;
static const CGFloat startPointY=0.33;
static const CGFloat endPointX=0.5;
static const CGFloat endPointY=1.0;
static const CGFloat defaultCellHeight=224.0;
static NSString *placeHolderImageName=@"wide-placeholder";

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setGradientLayer];
}

-(void)setGradientLayer{
    _myGradientLayer=[[CAGradientLayer alloc]init];
    
    _myGradientLayer.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height);
    
    _myGradientLayer.startPoint = CGPointMake(startPointX,startPointY);
    _myGradientLayer.endPoint = CGPointMake(endPointX, endPointY);
    _myGradientLayer.colors = [NSArray arrayWithObjects:(id)[[MovieAppConfiguration getGradientStartPointColor] CGColor],
                               (id)[[MovieAppConfiguration getGradientMiddlePointColor] CGColor],
                               (id)[[MovieAppConfiguration getGradientEndPointColor] CGColor],
                               nil];
    [self.viewForGradient.layer addSublayer:_myGradientLayer];
    self.viewForGradient.layer.masksToBounds = YES;
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _myGradientLayer.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height);
}

-(void)setupWithName:(NSString *)name imageUrl:(NSURL *)imageUrl{
    self.nameLabel.text=name;
    if(imageUrl){
        [self.profileImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:placeHolderImageName]];
    }
}

-(void)setupWithCastMember:(CastMember *)castMember{
    self.nameLabel.text=castMember.name;
    if(castMember.profileImageUrl){
        NSString *imageFullUrlPath=[BaseImageUrlForWidth500 stringByAppendingString:castMember.profileImageUrl];
        UIImage *image=[[DatabaseManager sharedDatabaseManager] getUIImageFromImageDbWithID:imageFullUrlPath];
        if(image){
            self.profileImageView.image=image;
        }
        else if([MovieAppConfiguration isConnectedToInternet]){
            [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:imageFullUrlPath] placeholderImage:[UIImage imageNamed:placeHolderImageName] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [[DatabaseManager sharedDatabaseManager] addUIImage:image toImageDbWithID:imageFullUrlPath];
            }];
        }
        else{
            
        }
        

    }
}

+(NSString *)cellClassName{
    return @"CastMemberPictureTableViewCell";
}

+(NSString *)cellIdentifier{
    return [self cellClassName];
}

-(CGFloat)cellHeight{
    return defaultCellHeight;
}


@end
