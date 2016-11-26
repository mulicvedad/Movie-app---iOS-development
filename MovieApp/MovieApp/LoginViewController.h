#import <UIKit/UIKit.h>
#import "LoginManager.h"
#import "LoginManagerDelagate.h"

typedef  enum{
    LoginValidationStatusCompletedSuccessfully,
    LoginValidationStatusCompletedUnsuccessfully,
    LoginValidationStatusUsernameEmpty,
    LoginValidationStatusPasswordEmpty,
    LoginValidationStatusPasswordNotLongEnough,
    LoginValidationStatusValidated
    
    
}LoginValidationStatus;

@interface LoginViewController : UIViewController <LoginManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *forgotDetailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *createNewAccountLabel;
@property (weak, nonatomic) IBOutlet UIView *usernameUnderlineView;
@property (weak, nonatomic) IBOutlet UIView *passwordUnderlineView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *createNewAccBottomContraint;

+(NSString *)getDescriptionForLoginValidationStatus:(LoginValidationStatus)loginStatus;
+(NSString *)getAlertTitleForLoginValidationStatus:(LoginValidationStatus)loginStatus;

@end
