#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *registerWebView;
@property (nonatomic) BOOL shouldResetPassword;

@end
