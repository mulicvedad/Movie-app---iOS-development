#import <UIKit/UIKit.h>
#import "TVEvent.h"

@interface MovieWidgetTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;

-(void)setupWithTVEvent:(TVEvent *)tvEvent;
@end
