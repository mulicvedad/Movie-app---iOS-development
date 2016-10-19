#import "SeasonsTableViewCell.h"

@interface SeasonsTableViewCell(){
    id<SeasonsTableViewCellDelegate> _delegate;
}
@end
@implementation SeasonsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)registerDelegate:(id<SeasonsTableViewCellDelegate>)delegate{
    _delegate=delegate;
}
+(NSString *)cellIdentifier{
    return [self cellIClassName];
}

+(NSString *)cellIClassName{
    return @"SeasonsTableViewCell";
}

-(void)setupWithNumberOfSeasons:(NSUInteger)numberOfSeasons years:(NSString *)years{
    NSMutableString *seasonsAsString=[NSMutableString stringWithString:@""];
    
    if(numberOfSeasons==0){
        self.seeAllButton.hidden=YES;
    }
    else{
        self.seeAllButton.hidden=NO;

    }

    for(int i=(int)numberOfSeasons;i>0;i--){
        [seasonsAsString appendFormat:@"%d ",i ];
    }
   
    
    self.seasonsLabel.text=seasonsAsString;
    self.yearsLabel.text=years;
}

- (IBAction)showSeasonsDetaills:(UIButton *)sender {
    [_delegate showSeasons];
}

@end
