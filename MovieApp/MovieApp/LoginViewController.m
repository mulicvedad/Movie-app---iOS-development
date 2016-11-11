#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LoginManager.h"
#import "LoginRequest.h"
#import <KeychainItemWrapper.h>
#import "VirtualDataStorage.h"
#import "RegisterViewController.h"

static NSString *UsernamePlaceholder=@"  Your username";
static NSString *PasswordPlaceholder=@"  Password";
static NSString *RegisterSegueIdentifier=@"RegisterSegue";
static NSString *ResetPasswordSegueIdentifier=@"ResetSegue";
static CGFloat ContainerViewOffsetWithoutKeyboard=200.0;
static CGFloat ContainerViewOffsetWithKeyboard=50.0;

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
    KeychainItemWrapper *myWrapper=[[KeychainItemWrapper alloc] initWithIdentifier:KeyChainItemWrapperIdentifier accessGroup:nil];
    [myWrapper setObject:self.usernameTextField.text forKey:(id)kSecAttrAccount];
    [myWrapper setObject:sessionID forKey:(id)kSecValueData];
    [[VirtualDataStorage sharedVirtualDataStorage] updateData];
}

-(void)loginFailedWithError:(NSError *)error{
    [self notifyUserOfValidationStatus:LoginValidationStatusCompletedUnsuccessfully];
}

-(void)didSelectCreateNewAccount:(UILabel *)sender{
    [self performSegueWithIdentifier:RegisterSegueIdentifier sender:nil];
}

-(void)didSelectForgotDetails:(UILabel *)sender{
    [self performSegueWithIdentifier:ResetPasswordSegueIdentifier sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:RegisterSegueIdentifier]){
        RegisterViewController *destVC=segue.destinationViewController;
        destVC.shouldResetPassword=NO;
    }
    else if([segue.identifier isEqualToString:ResetPasswordSegueIdentifier]){
        RegisterViewController *destVC=segue.destinationViewController;
        destVC.shouldResetPassword=YES;
    }
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

-(void)keyboardWillShow {
    CGRect newFrame=self.containerView.frame;
    newFrame.origin.y=ContainerViewOffsetWithKeyboard;
    self.containerView.frame = newFrame;
}

-(void)keyboardWillHide {
    CGRect newFrame=self.containerView.frame;
    newFrame.origin.y=ContainerViewOffsetWithoutKeyboard;
    self.containerView.frame = newFrame;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];  
}



@end
