#import "SortByDropDownTableViewCell.h"

static NSString * const CheckedImageName=@"checked";

@implementation SortByDropDownTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

+(NSString *)cellIdentifier{
    return [self cellIClassName];
}

+(NSString *)cellIClassName{
    return @"SortByDropDownTableViewCell";
}

-(void)setupWithCriterion:(NSString *)criterion isSelected:(BOOL)selected{
    self.sortCriterionLabel.text=criterion;
    
    if(selected){
        self.arrowImageView.image=[UIImage imageNamed:CheckedImageName];
    }
    else{
        self.arrowImageView.image=nil;
    }
}

@end
