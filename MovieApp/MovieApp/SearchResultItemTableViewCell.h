#import <UIKit/UIKit.h>
#import "ShowDetailsDelegate.h"

@interface SearchResultItemTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;

-(void)setupWithTitle:(NSAttributedString *)title rating:(float)voteAverage imageUrl:(NSURL *)imagePosterUrl;
+(NSString *)cellIdentifier;
+(NSString *)cellIClassName;
-(void)registerDelegate:(id<ShowDetailsDelegate>)delegate tableViewRowNumber:(NSUInteger)rowIndex;
@end