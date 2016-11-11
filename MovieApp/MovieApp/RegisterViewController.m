#import "RegisterViewController.h"

@interface RegisterViewController (){
    BOOL _isPostRequestActive;
}

@end
static NSString *RegisterTheMovieDBURLPath=@"https://www.themoviedb.org/account/signup";
static NSString *ResetPasswordTheMovieDBURLPath=@"https://www.themoviedb.org/account/reset-password";
static NSString *RegisterSucceededCookieName=@"login";

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURLRequest *request;
    if(self.shouldResetPassword){
        request=[NSURLRequest requestWithURL:[NSURL URLWithString:ResetPasswordTheMovieDBURLPath]];
        self.navigationItem.title=@"Reset password";
    }
    else{
        request=[NSURLRequest requestWithURL:[NSURL URLWithString:RegisterTheMovieDBURLPath]];
        self.navigationItem.title=@"Sign Up";
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.registerWebView loadRequest:request];
    self.registerWebView.delegate=self;
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if([request.HTTPMethod isEqualToString:@"POST"]){
        _isPostRequestActive=YES;
    }
    NSArray<NSHTTPCookie *> *cookies=[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    
    for(NSHTTPCookie *cookie in cookies){
        if([cookie.name isEqualToString:RegisterSucceededCookieName]){
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSArray<NSHTTPCookie *> *cookies=[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for(NSHTTPCookie *cookie in cookies){
        if([cookie.name isEqualToString:RegisterSucceededCookieName] && _isPostRequestActive){
            [self didFinishRegistration];
            return;
        }
    }
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}


-(void)webViewDidStartLoad:(UIWebView *)webView{
    
}
-(void)didFinishRegistration{
    NSMutableAttributedString *alertTitle = [[NSMutableAttributedString alloc] initWithString:@"Success" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    NSMutableAttributedString *alertMessage = [[NSMutableAttributedString alloc] initWithString:@"\nCheck your email to finish regisration!" attributes:@{NSForegroundColorAttributeName:[MovieAppConfiguration getPrefferedLightGreyColor],                                                   NSFontAttributeName:[MovieAppConfiguration getPreferredFontWithSize:12 isBold:NO ]}];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:EmptyString
                                                                   message:EmptyString
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert setValue:alertTitle forKey:@"attributedTitle"];
    [alert setValue:alertMessage forKey:@"attributedMessage"];
    
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self.navigationController popViewControllerAnimated:YES];
                                                          }];
    
    [alert addAction:defaultAction];
    alert.view.tintColor=[MovieAppConfiguration getPrefferedYellowColorWithOpacity:0.5f];
    
    UIView *subView = alert.view.subviews.firstObject;
    UIView *alertContentView = subView.subviews.firstObject;
    for (UIView *subSubView in alertContentView.subviews) {
        subSubView.backgroundColor = [MovieAppConfiguration getPreferredDarkGreyColor];
    }
    [self presentViewController:alert animated:YES completion:nil];
}



@end
