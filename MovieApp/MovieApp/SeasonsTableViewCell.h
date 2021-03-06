#import <UIKit/UIKit.h>
#import "SeasonsTableViewCellDelegate.h"
#import "TvShowSeason.h"

@interface SeasonsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *seasonsLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearsLabel;
@property (weak, nonatomic) IBOutlet UIButton *seeAllButton;

-(void)setupWithNumberOfSeasons:(NSUInteger)numberOfSeasons years:(NSString *)years;
-(void)setupWithSeasons:(NSArray *)seasons;
-(void)registerDelegate:(id<SeasonsTableViewCellDelegate>)delegate;
+(NSString *)cellIdentifier;
+(NSString *)cellIClassName;

@end
