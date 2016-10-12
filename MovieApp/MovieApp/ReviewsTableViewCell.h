#import <UIKit/UIKit.h>

@interface ReviewsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewLabel;
@property (weak, nonatomic) IBOutlet UITextView *readMoreTextView;


-(void)setupWithAuthorName:(NSString *)name reviewText:(NSString *)review readMoreURL:(NSURL *)url;

+(NSString *)cellIdentifier;
+(NSString *)cellIClassName;

@end
