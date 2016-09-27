#import <UIKit/UIKit.h>

@interface NewsFeedItemView : UIView

@property (strong, nonatomic) IBOutlet UIView *feedView;
@property (weak, nonatomic) IBOutlet UILabel *labelHeadline;
@property (weak, nonatomic) IBOutlet UITextView *textViewText;


@end
