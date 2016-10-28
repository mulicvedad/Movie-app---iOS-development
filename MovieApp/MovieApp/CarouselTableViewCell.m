#import "CarouselTableViewCell.h"

@implementation CarouselTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}


+(NSString *)cellClassName{
    return @"CarouselTableViewCell";
}
+(NSString *)cellIdentifier{

    return  [self cellClassName];
}

@end
