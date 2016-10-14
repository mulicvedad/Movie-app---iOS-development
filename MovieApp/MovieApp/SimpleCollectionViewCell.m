#import "SimpleCollectionViewCell.h"

@implementation SimpleCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(NSString *)cellIdentifier{
    return [self cellIClassName];
}

+(NSString *)cellIClassName{
    return @"SimpleCollectionViewCell";
}

@end
