//
//  LoginViewController.m
//  ShareBuyUser
//
//  Created by Marx on 16/8/9.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ResetPasswordViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property(nonatomic)UIImageView *bgImageView;

@property(nonatomic)UIButton *cancelButton;

@property(nonatomic)UITextField *accountTextField;
@property(nonatomic)UITextField *passwordTextField;

@property(nonatomic)UIButton *forgetPasswordButton;

@property(nonatomic)UIButton *loginButton;
@property(nonatomic)UIButton *registerButton;

@property(nonatomic)UIButton *wechatAuthLoginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    [[BaseTabBarController shareTabBarController].title setAlpha:0];
    [[BaseTabBarController shareTabBarController] setTitle:@""];
    [self.nav.alphaView setAlpha:0];
}

#pragma mark Custom View
- (void)customView
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(selectCancelButton:)];
    [self.view addSubview:self.bgImageView];
}

- (UIImageView *)bgImageView
{
    if (!_bgImageView) {
        _bgImageView = ({
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -kNavigationBarHight, kScreenWidth, kScreenHeight)];
            [imageView setUserInteractionEnabled:YES];
            [imageView setImage:[UIImage imageNamed:@"login_bg_image"]];
            
//            [imageView addSubview:self.cancelButton];
            
            UIView *accountBgView = [[UIView alloc] initWithFrame:CGRectMake(40*kWR, 135*kWR, kScreenWidth-80*kWR, 40)];
            [accountBgView.layer setMasksToBounds:YES];
            [accountBgView.layer setCornerRadius:5];
            [accountBgView setBackgroundColor:[UIColor whiteColor]];
            
            UIImageView *accountImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7.5, 7.5, 25, 25)];
            [accountImageView setImage:[UIImage imageNamed:@"account_textfield_image"]];
            [accountBgView addSubview:accountImageView];
            
            UIView *accountLineView = [[UIView alloc] initWithFrame:CGRectMake(49.75, 5, 0.5, 30)];
            [accountLineView setBackgroundColor:UIColorFromHex(0xbbbbbb, 1)];
            [accountBgView addSubview:accountLineView];
            
            [accountBgView addSubview:self.accountTextField];
            
            [imageView addSubview:accountBgView];
            
            
            UIView *passwordBgView = [[UIView alloc] initWithFrame:CGRectMake(40*kWR, 135*kWR +55, kScreenWidth-80*kWR, 40)];
            [passwordBgView.layer setMasksToBounds:YES];
            [passwordBgView.layer setCornerRadius:5];
            [passwordBgView setBackgroundColor:[UIColor whiteColor]];
            
            UIImageView *passwordImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7.5, 7.5, 25, 25)];
            [passwordImageView setImage:[UIImage imageNamed:@"password_textfield_image"]];
            [passwordBgView addSubview:passwordImageView];
            
            UIView *passwordLineView = [[UIView alloc] initWithFrame:CGRectMake(49.75, 5, 0.5, 30)];
            [passwordLineView setBackgroundColor:UIColorFromHex(0xbbbbbb, 1)];
            [passwordBgView addSubview:passwordLineView];
            
            [passwordBgView addSubview:self.passwordTextField];
            
            [imageView addSubview:passwordBgView];
            
            [imageView addSubview:self.forgetPasswordButton];
            [imageView addSubview:self.loginButton];
            [imageView addSubview:self.registerButton];
            
            UIView *authLoginLineView_1 = [[UIView alloc] initWithFrame:CGRectMake(0, 175*kWR +279.75, (kScreenWidth-80)/2, 0.5)];
            [authLoginLineView_1 setBackgroundColor:UIColorFromHex(0xbbbbbb, 1)];
            [imageView addSubview:authLoginLineView_1];
            
            UIView *authLoginLineView_2 = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2+40, 175*kWR +279.75, (kScreenWidth-80)/2, 0.5)];
            [authLoginLineView_2 setBackgroundColor:UIColorFromHex(0xbbbbbb, 1)];
            [imageView addSubview:authLoginLineView_2];
            
            UILabel *authLoginLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-80)/2,175*kWR + 270, 80, 20)];
            [authLoginLabel setTextAlignment:NSTextAlignmentCenter];
            [authLoginLabel setTextColor:[UIColor whiteColor]];
            [authLoginLabel setFont:UIFontPingFangLight(11)];
            [authLoginLabel setText:@"合作商账号登录"];
            [imageView addSubview:authLoginLabel];
            
            [imageView addSubview:self.wechatAuthLoginButton];
            
            imageView;
        });
    }
    
    return _bgImageView;
}

- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(5, 20, 44, 44)];
            [button setTitle:@"取消" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button.titleLabel setFont:UIFontPingFangRegular(15)];
            
            [button addTarget:self action:@selector(selectCancelButton:) forControlEvents:UIControlEventTouchUpInside];
            
            button;
        });
    }
    return _cancelButton;
}

- (UITextField *)accountTextField
{
    if (!_accountTextField) {
        _accountTextField = ({
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(65, 5, kScreenWidth-80*kWR - 80, 30)];
            [textField setDelegate:self];
            [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
            [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            [textField setReturnKeyType:UIReturnKeyDone];
            [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
            
            [textField setTextColor:UIColorFromHex(0x696969, 1)];
            [textField setFont:UIFontPingFangRegular(15)];
            
            [textField setPlaceholder:@"请输入账号"];
            textField;
        });
    }
    
    return _accountTextField;
}

- (UITextField *)passwordTextField
{
    if (!_passwordTextField) {
        _passwordTextField = ({
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(65, 5, kScreenWidth-80*kWR -80, 30)];
            [textField setDelegate:self];
            [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
            [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            [textField setReturnKeyType:UIReturnKeyDone];
            [textField setSecureTextEntry:YES];
            [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
            
            [textField setTextColor:UIColorFromHex(0x696969, 1)];
            [textField setFont:UIFontPingFangRegular(15)];
            
            [textField setPlaceholder:@"请输入密码"];
            textField;
        });
    }
    return _passwordTextField;
}

- (UIButton *)forgetPasswordButton
{
    if (!_forgetPasswordButton) {
        _forgetPasswordButton = ({
            UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(kScreenWidth - 40*kWR - 60, 135*kWR +55 +40, 60, 40)];
            [button setTitle:@"忘记密码" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button.titleLabel setFont:UIFontPingFangLight(13)];
            
            [button addTarget:self action:@selector(selectForgetPasswordButton:) forControlEvents:UIControlEventTouchUpInside];
            
            button;
        });
    }
    return _forgetPasswordButton;
}

- (UIButton *)loginButton
{
    if (!_loginButton) {
        _loginButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(40*kWR, 135*kWR +55 +40 + 70, kScreenWidth - 80*kWR, 40*kWR)];
            [button.layer setMasksToBounds:YES];
            [button.layer setCornerRadius:20*kWR];
            
            [button setBackgroundImage:[UIImage imageWithColor:kMainColor size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
            [button setTitle:@"登录" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button.titleLabel setFont:UIFontPingFangRegular(17)];
            
            [button addTarget:self action:@selector(selectLoginButton:) forControlEvents:UIControlEventTouchUpInside];
            
            button;
        });
    }
    return _loginButton;
}

- (UIButton *)registerButton
{
    if (!_registerButton) {
        _registerButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(40*kWR, 135*kWR +55 +40 + 70 + 40*kWR+15, kScreenWidth - 80*kWR, 40*kWR)];
            [button.layer setMasksToBounds:YES];
            [button.layer setCornerRadius:20*kWR];
            
            [button setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(0xffa08e, 1) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
            [button setTitle:@"注册" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button.titleLabel setFont:UIFontPingFangRegular(17)];
            
            [button addTarget:self action:@selector(selectRegisterButton:) forControlEvents:UIControlEventTouchUpInside];
            
            button;
        });
    }
    return _registerButton;
}

- (UIButton *)wechatAuthLoginButton
{
    if (!_wechatAuthLoginButton) {
        _wechatAuthLoginButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            [button setFrame:CGRectMake((kScreenWidth - 70)/2, 175*kWR + 290 +20, 70, 70)];
            [button setImage:[UIImage imageNamed:@"login_wechat_auth_button_normal"] forState:UIControlStateNormal];
            
            button;
        });
    }
    return _wechatAuthLoginButton;
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark Button Action

- (IBAction)selectCancelButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)selectLoginButton:(id)sender
{
    if (_accountTextField.text.length>0&&_passwordTextField.text.length>0) {
        [self requestLoginData];
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入用户名及密码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
    }
}

- (IBAction)selectRegisterButton:(id)sender
{
    [self.navigationController pushViewController:[RegisterViewController new] animated:YES];
}

- (IBAction)selectForgetPasswordButton:(id)sender
{
    ResetPasswordViewController *vc = [ResetPasswordViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark Request Data
- (void)requestLoginData
{
    NSDictionary *dict = @{@"phone":_accountTextField.text,@"password":_passwordTextField.text};
    
    [self showHudInView:self.view hint:nil];
    [DDPBLL requestWithURL:DEF_URL_Login Dict:dict result:^(NSDictionary *responseDict) {
        [self hideHud];
        if (responseDict == nil) {
            [self showHint:@"处理失败，请稍后再试"];
            return ;
        }
        if ([[responseDict objectForKey:@"status"] integerValue]==0) {
            [self showHint:responseDict[@"msg"]];
            [[UserModel shareUserModel] setUserToken:responseDict[@"data"][0][@"token"]];
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }else{
            [self showHint:responseDict[@"msg"] yOffset:-250];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
