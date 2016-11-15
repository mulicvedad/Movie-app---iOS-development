#import <UIKit/UIKit.h>
#import "TVEvent.h"

@interface LikedTVEventTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;

-(void)setupWithTvEvent:(TVEvent *)tvEvent;

@end
