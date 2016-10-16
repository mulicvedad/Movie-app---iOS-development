#import "MainSortByTableViewCell.h"

#define ACTIVE_DROPDOWN_IMAGE_NAME @"up arrow"
#define INACTIVE_DROPDOWN_IMAGE_NAME @"down arrow"

@implementation MainSortByTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

+(NSString *)cellIdentifier{
    return [self cellIClassName];
}

+(NSString *)cellIClassName{
    return @"MainSortByTableViewCell";
}

-(void)setupWithCriterion:(NSString *)criterion isDropDownActive:(BOOL)dropDownStateIsActive{
    self.sortCriterionLabel.text=criterion;
    if(dropDownStateIsActive){
        self.arrowImageView.image=[UIImage imageNamed:ACTIVE_DROPDOWN_IMAGE_NAME];
    }
    else{
        self.arrowImageView.image=[UIImage imageNamed:INACTIVE_DROPDOWN_IMAGE_NAME];
    }
}

@end
