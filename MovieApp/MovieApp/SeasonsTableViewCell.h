#import <UIKit/UIKit.h>
#import "SeasonsTableViewCellDelegate.h"

@interface SeasonsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *seasonsLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearsLabel;

-(void)setupWithNumberOfSeasons:(NSUInteger)numberOfSeasons years:(NSString *)years;
-(void)registerDelegate:(id<SeasonsTableViewCellDelegate>)delegate;
+(NSString *)cellIdentifier;
+(NSString *)cellIClassName;

@end