#import "MainSortByTableViewCell.h"

static NSString * const ActiveDropdownImageName=@"up arrow";
static NSString * const InactiveDropdownImageName= @"down arrow";

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
        self.arrowImageView.image=[UIImage imageNamed:ActiveDropdownImageName];
    }
    else{
        self.arrowImageView.image=[UIImage imageNamed:InactiveDropdownImageName];
    }
}

@end
