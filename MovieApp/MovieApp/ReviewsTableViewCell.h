#import <UIKit/UIKit.h>
#import "TVEventReview.h"

@interface ReviewsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewLabel;
@property (weak, nonatomic) IBOutlet UITextView *readMoreTextView;


-(void)setupWithAuthorName:(NSString *)name reviewText:(NSString *)review readMoreURL:(NSURL *)url;
-(void)setupWithReview:(TVEventReview *)review;
+(NSString *)cellIdentifier;
+(NSString *)cellIClassName;

@end
