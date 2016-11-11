#import "CarouselCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

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
        [self.posterImageView sd_setImageWithURL:[NSURL URLWithString:[BaseImageUrlForWidth92 stringByAppendingString:castMember.profileImageUrl]]];
    }
    self.nameLabel.text=castMember.name;
    self.rolesLabel.text=castMember.character;    
                                             
}

-(void)setupWithTVEvent:(TVEventCredit *)tvEvent castMember:(CastMember *)castMember{
    if(tvEvent.posterPath){
        [self.posterImageView sd_setImageWithURL:[NSURL URLWithString:[BaseImageUrlForWidth92 stringByAppendingString:tvEvent.posterPath]]];
    }
    self.nameLabel.numberOfLines=3;
    self.nameLabel.text=tvEvent.title;
    self.rolesLabel.text=castMember.character;
    
}
@end
