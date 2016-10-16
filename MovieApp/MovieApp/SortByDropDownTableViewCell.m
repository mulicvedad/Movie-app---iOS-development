#import "SortByDropDownTableViewCell.h"

#define CHECKED_IMAGE_NAME @"checked"

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
        self.arrowImageView.image=[UIImage imageNamed:CHECKED_IMAGE_NAME];
    }
    else{
        self.arrowImageView.image=nil;
    }
}

@end
