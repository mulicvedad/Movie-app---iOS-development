#import "CastMemberInfoTableViewCell.h"

@implementation CastMemberInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setupWithCastMember:(CastMember *)castMemeber{
    
}

+(NSString *)cellClassName{
    return @"CastMemberInfoTableViewCell";
}

+(NSString *)cellIdentifier{
    return [self cellClassName];
}

@end
