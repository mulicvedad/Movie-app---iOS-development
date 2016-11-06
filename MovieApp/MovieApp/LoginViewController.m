#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LoginManager.h"
#import "LoginRequest.h"
#import <KeychainItemWrapper.h>

static NSString *UsernamePlaceholder=@"  Your username";
static NSString *PasswordPlaceholder=@"  Password";

@interface LoginViewController (){
   
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureSubviews];
    
}

-(void)configureSubviews{
    self.usernameTextField.borderStyle=UITextBorderStyleNone;
    self.passwordTextField.borderStyle=UITextBorderStyleNone;
    self.loginButton.layer.cornerRadius=15.0f;
    self.loginButton.clipsToBounds=YES;
    
    NSAttributedString *usernamePlaceholder = [[NSAttributedString alloc] initWithString:UsernamePlaceholder attributes:@{ NSForegroundColorAttributeName : [MovieAppConfiguration getPrefferedGreyColor] }];
    NSAttributedString *passwordPlaceholder = [[NSAttributedString alloc] initWithString:PasswordPlaceholder attributes:@{ NSForegroundColorAttributeName : [MovieAppConfiguration getPrefferedGreyColor] }];
    self.usernameTextField.attributedPlaceholder = usernamePlaceholder;
    self.passwordTextField.attributedPlaceholder = passwordPlaceholder;
    
    [ self.createNewAccountLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectCreateNewAccount:)]];
    [ self.forgotDetailsLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectForgotDetails:)]];

}

- (IBAction)didBeginEditingTextfield:(UITextField *)sender {
    if(sender==self.usernameTextField){
        self.usernameUnderlineView.backgroundColor=[MovieAppConfiguration getPrefferedYellowColorWithOpacity:0.5f];
    }
    else{
        self.passwordUnderlineView.backgroundColor=[MovieAppConfiguration getPrefferedYellowColorWithOpacity:0.5f];
    }
}
- (IBAction)didEndEditingTextfield:(UITextField *)sender {
    if(sender==self.usernameTextField){
        self.usernameUnderlineView.backgroundColor=[MovieAppConfiguration getPrefferedLightGreyColor];
    }
    else{
        self.passwordUnderlineView.backgroundColor=[MovieAppConfiguration getPrefferedLightGreyColor];
    }
}
- (IBAction)didSelectLoginButton:(UIButton *)sender {
    LoginManager *apiLoginManager=[[LoginManager alloc]init];
    LoginValidationStatus loginStatus=[self validateTextFields];
    if(loginStatus==LoginValidationStatusValidated){
        LoginRequest *loginRequest=[[LoginRequest alloc] initWithUsername:self.usernameTextField.text password:self.passwordTextField.text];
        [apiLoginManager loginWithLoginRequest:loginRequest delegate:self];
    }
    else{
        [self notifyUserOfValidationStatus:loginStatus];
    }
}

-(void)loginSucceededWithSessionID:(NSString *)sessionID{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IsUserLoggedInNSUserDefaultsKey];
    [[NSUserDefaults standardUserDefaults] setObject:self.usernameTextField.text forKey:UsernameNSUserDefaultsKey];

    KeychainItemWrapper *myWrapper=[[KeychainItemWrapper alloc] initWithIdentifier:KeyChainItemWrapperIdentifier accessGroup:nil];
    [myWrapper setObject:sessionID forKey:kSecValueData];

    [self notifyUserOfValidationStatus:LoginValidationStatusCompletedSuccessfully];
}

-(void)loginFailedWithError:(NSError *)error{
    [self notifyUserOfValidationStatus:LoginValidationStatusCompletedUnsuccessfully];
}

-(void)didSelectCreateNewAccount:(UILabel *)sender{
    //not implemented yet
}

-(void)didSelectForgotDetails:(UILabel *)sender{
    //not implemented yet
}

-(LoginValidationStatus)validateTextFields{
    
    if([self.usernameTextField.text length]==0){
        return LoginValidationStatusUsernameEmpty;
    }
    else if([self.passwordTextField.text length]==0){
        return LoginValidationStatusPasswordEmpty;
    }
    else if([self.passwordTextField.text length]<4)
    {
        return LoginValidationStatusPasswordNotLongEnough;
    }
    else{
        return LoginValidationStatusValidated;
    }
}

-(void)notifyUserOfValidationStatus:(LoginValidationStatus)status{
    
    NSMutableAttributedString *alertTitle = [[NSMutableAttributedString alloc] initWithString:[LoginViewController getAlertTitleForLoginValidationStatus:status] attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    NSMutableAttributedString *alertMessage = [[NSMutableAttributedString alloc] initWithString:[LoginViewController getDescriptionForLoginValidationStatus:status] attributes:@{NSForegroundColorAttributeName:[MovieAppConfiguration getPrefferedLightGreyColor],                                                   NSFontAttributeName:[MovieAppConfiguration getPreferredFontWithSize:12 isBold:NO ]}];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:EmptyString
                                                                   message:EmptyString
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert setValue:alertTitle forKey:@"attributedTitle"];
    [alert setValue:alertMessage forKey:@"attributedMessage"];
    

    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         if(status==LoginValidationStatusCompletedSuccessfully){
                                                             [self.navigationController popViewControllerAnimated:YES];
                                                         }
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

+(NSString *)getDescriptionForLoginValidationStatus:(LoginValidationStatus)loginStatus{
    return @[@"\nLogin completed succesfully!",
             @"\nWrong username or password!",
             @"\nUsername field cannot be empty!",
             @"\nPassword field cannot be empty!",
             @"\nPassword field must be at least 4 characters long!",@""][loginStatus];
}
+(NSString *)getAlertTitleForLoginValidationStatus:(LoginValidationStatus)loginStatus{
    if(loginStatus==LoginValidationStatusCompletedSuccessfully){
        return @"Done";
    }
    else if(loginStatus==LoginValidationStatusCompletedUnsuccessfully){
        return @"Login failed";
    }
    else{
        return @"Error";
    }
}



@end
