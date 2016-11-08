#import <UIKit/UIKit.h>
#import "ShowDetailsDelegate.h"
#import "TVEvent.h"

@interface SearchResultItemTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *arrowButtob;

-(void)setupWithTitle:(NSAttributedString *)title rating:(float)voteAverage imageUrl:(NSURL *)imagePosterUrl;
-(void)setupWithTvEvent:(TVEvent *)tvEvent;
+(NSString *)cellIdentifier;
+(NSString *)cellIClassName;
-(void)registerDelegate:(id<ShowDetailsDelegate>)delegate tableViewRowNumber:(NSUInteger)rowIndex;
-(void)configureForLikedTVEvents;

@end
