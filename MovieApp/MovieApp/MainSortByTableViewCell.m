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

-(void)setupWithCriterion:(NSString *)criterion isDropDownActive:(BOOL)dropDownStateIsActive isFilterBy:(BOOL)filter{
    self.sortCriterionLabel.text=criterion;
    if(filter){
        self.sortByLabel.text=@"Filter by: ";
    }
    else{
        self.sortByLabel.text=@"Sort by: ";

    }
    if(dropDownStateIsActive){
        self.arrowImageView.image=[UIImage imageNamed:ActiveDropdownImageName];
    }
    else{
        self.arrowImageView.image=[UIImage imageNamed:InactiveDropdownImageName];
    }
}

@end
