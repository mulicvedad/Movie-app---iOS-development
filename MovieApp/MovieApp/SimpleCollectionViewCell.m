#import "SimpleCollectionViewCell.h"

@implementation SimpleCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

+(NSString *)cellIdentifier{
    return [self cellIClassName];
}

+(NSString *)cellIClassName{
    return @"SimpleCollectionViewCell";
}

@end
