#import "CastTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define PLACEHOLDER_IMAGE_NAME @"poster-placeholder"

@implementation CastTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureView];
}
-(void)configureView{
  
    for(int i=0;i<[self.castStackView.subviews count];i++){
        UIStackView *currentStackView=(UIStackView *)_castStackView.subviews[i];
        UIImageView *posterImageView=(UIImageView *)currentStackView  .subviews[0];
        
        CGRect newFrame = CGRectMake( posterImageView.frame.origin.x, posterImageView.frame.origin.y, posterImageView.frame.size.width,posterImageView.frame.size.width/0.66667f);
        
        [posterImageView setFrame:newFrame];
    }
}

-(void)setupWithImageUrls:(NSArray *)urls correspondingNames:(NSArray *)names roles:(NSArray *)roles{
    
    if([urls count]>0){
        for(int i=0;i<[self.castStackView.subviews count] && i<[urls count] && i<[roles count];i++){
            UIStackView *currentStackView=(UIStackView *)_castStackView.subviews[i];
            UIImageView *posterImageView=(UIImageView *)currentStackView .subviews[0];
            UILabel *nameLabel=(UILabel *)currentStackView.subviews[1];
            UILabel *roleLabel=(UILabel *)currentStackView.subviews[2];
            
            [posterImageView sd_setImageWithURL:urls[i] placeholderImage:[UIImage imageNamed:PLACEHOLDER_IMAGE_NAME]];
            nameLabel.text=names[i];
            roleLabel.text=roles[i];
            
        }
    }
}

+(NSString *)cellIdentifier{
    return [self cellIClassName];
}

+(NSString *)cellIClassName{
    return @"CastTableViewCell";
}


@end
