#import <UIKit/UIKit.h>
#import "TVEvent.h"

@interface MainMovieWidgetTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;

-(void)setupWithTVEvent:(TVEvent *)tvEvent;
@end
