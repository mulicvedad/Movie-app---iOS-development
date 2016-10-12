#import <SDWebImage/UIImageView+WebCache.h>


#import "AlternativeCastTableViewCell.h"
#define BASE_IMAGE_URL @"http://image.tmdb.org/t/p/w92"
#define IMAGE_RATIO 0.66667
@interface AlternativeCastTableViewCell (){
    NSArray *imageViews;
    NSArray *nameLabels;
    NSArray *roleLabels;
}
@end

@implementation AlternativeCastTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configure];
}

-(void)configure{
    imageViews=@[_firstImageView,_secondImageView,_thirdImageView,_fourthImageView];
    nameLabels=@[_firstNameLabel, _secondNameLabel, _thirdNameLabel, _fourthNameLabel];
    roleLabels=@[_firstRoleLabel, _secondRoleLabel, _thirdRoleLabel, _fourthRoleLabel];
}
+(NSString *)cellIdentifier{
    return [self cellIClassName];
}

+(NSString *)cellIClassName{
    return @"AlternativeCastTableViewCell";
}

-(void)setupWithImageUrls:(NSArray *)urls correspondingNames:(NSArray *)names roles:(NSArray *)roles{
    for(int i=0;i<[urls count];i++){
        UIImageView *currentImageView=(UIImageView *)imageViews[i];
        [currentImageView sd_setImageWithURL:urls[i] completed:^(UIImage *image, NSError *error, SDImageCacheType cache, NSURL *url){
           // CGRect newFrame=CGRectMake(currentImageView.frame.origin.x, currentImageView.frame.origin.y, currentImageView.frame.size.width, currentImageView.frame.size.width/IMAGE_RATIO);
            //currentImageView.frame=newFrame;
        }];
        
        ((UILabel *)nameLabels[i]).text=names[i];
        ((UILabel *)roleLabels[i]).text=roles[i];
    }
}


@end
