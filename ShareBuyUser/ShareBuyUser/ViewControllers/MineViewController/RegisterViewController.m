//
//  RegisterViewController.m
//  ShareBuyUser
//
//  Created by Marx on 16/8/9.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()<UITextFieldDelegate>

@property(nonatomic)UITextField *phoneTextField;

@property(nonatomic)UITextField *passwordTextField;

@property(nonatomic)UITextField *verificationCodeTextField;

@property(nonatomic)UIButton *sendCodeButton;
@property(nonatomic)NSTimer *timer;
@property(nonatomic)NSInteger interval;

@property(nonatomic)UIButton *agreeButton;

@property(nonatomic)UIButton *agreementButton;

@property(nonatomic)UIButton *submitButton;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"注册"];
    [self customView];
}

#pragma mark Custom View
- (void)customView
{
    UIView *phoneBgView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, 15, kScreenWidth - 30, 40)];
        [view.layer setMasksToBounds:YES];
        [view.layer setCornerRadius:5];
        [view.layer setBorderColor:UIColorFromHex(0xbbbbbb, 1).CGColor];
        [view.layer setBorderWidth:0.5];
        
        [view setBackgroundColor:[UIColor whiteColor]];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(7.5, 7.5, 25, 25)];
        [imageView setImage:[UIImage imageNamed:@"phone_textfield_image"]];
        [view addSubview:imageView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(49.75, 5, 0.5, 30)];
        [lineView setBackgroundColor:UIColorFromHex(0xbbbbbb, 1)];
        [view addSubview:lineView];
        
        [view addSubview:self.phoneTextField];
        
        view;
    });
    
    [self.view addSubview:phoneBgView];
    
    UIView *passwordBgView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, 65, kScreenWidth - 30, 40)];
        [view.layer setMasksToBounds:YES];
        [view.layer setCornerRadius:5];
        [view.layer setBorderColor:UIColorFromHex(0xbbbbbb, 1).CGColor];
        [view.layer setBorderWidth:0.5];
        
        [view setBackgroundColor:[UIColor whiteColor]];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(7.5, 7.5, 25, 25)];
        [imageView setImage:[UIImage imageNamed:@"password_textfield_image"]];
        [view addSubview:imageView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(49.75, 5, 0.5, 30)];
        [lineView setBackgroundColor:UIColorFromHex(0xbbbbbb, 1)];
        [view addSubview:lineView];
        
        [view addSubview:self.passwordTextField];
        
        view;
    });
    
    [self.view addSubview:passwordBgView];
    
    UIView *verificationCodeBgView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, 115, (kScreenWidth - 40)/5*3, 40)];
        [view.layer setMasksToBounds:YES];
        [view.layer setCornerRadius:5];
        [view.layer setBorderColor:UIColorFromHex(0xbbbbbb, 1).CGColor];
        [view.layer setBorderWidth:0.5];
        
        [view setBackgroundColor:[UIColor whiteColor]];
        
        [view addSubview:self.verificationCodeTextField];
        
        view;
    });
    
    [self.view addSubview:verificationCodeBgView];
    
    [self.view addSubview:self.sendCodeButton];
    [self.view addSubview:self.agreeButton];
    [self.view addSubview:self.agreementButton];
    [self.view addSubview:self.submitButton];
}

- (UITextField *)phoneTextField
{
    if (!_phoneTextField) {
        _phoneTextField = ({
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(65, 5, kScreenWidth-30 - 80, 30)];
            [textField setDelegate:self];
            [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
            [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            [textField setReturnKeyType:UIReturnKeyDone];
            [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
            
            [textField setTextColor:UIColorFromHex(0x696969, 1)];
            [textField setFont:UIFontPingFangRegular(15)];
            
            [textField setPlaceholder:@"请输入手机号"];
            textField;
        });
    }
    return _phoneTextField;
}

- (UITextField *)passwordTextField
{
    if (!_passwordTextField) {
        _passwordTextField = ({
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(65, 5, kScreenWidth-30 -80, 30)];
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

- (UITextField *)verificationCodeTextField
{
    if (!_verificationCodeTextField) {
        _verificationCodeTextField = ({
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 5, (kScreenWidth - 40)/5*3-30, 30)];
            [textField setDelegate:self];
            [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
            [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            [textField setReturnKeyType:UIReturnKeyDone];
            [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
            
            [textField setTextColor:UIColorFromHex(0x696969, 1)];
            [textField setFont:UIFontPingFangRegular(15)];
            
            [textField setPlaceholder:@"请输入短信验证码"];
            textField;
        });
    }
    return _verificationCodeTextField;
}

- (UIButton *)sendCodeButton
{
    if (!_sendCodeButton) {
        _sendCodeButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button.layer setMasksToBounds:YES];
            [button.layer setCornerRadius:5];
            [button setFrame:CGRectMake(kScreenWidth -15 - (kScreenWidth -40)/5*2, 115, (kScreenWidth -40)/5*2, 40)];
            [button setBackgroundImage:[UIImage imageWithColor:kMainColor size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
            [button setTitle:@"获取短信验证码" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button.titleLabel setFont:UIFontPingFangRegular(15)];
            
            [button addTarget:self action:@selector(selectSendCodeButton:) forControlEvents:UIControlEventTouchUpInside];
            
            button;
        });
    }
    
    return _sendCodeButton;
}

- (UIButton *)agreeButton
{
    if (!_agreeButton) {
        _agreeButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(5,155, 40, 40)];
            
            [button setImage:[UIImage imageNamed:@"agree_button_normal"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"agree_button_selected"] forState:UIControlStateSelected];
            
            [button addTarget:self action:@selector(selectAgreeButton:) forControlEvents:UIControlEventTouchUpInside];
            
            button;
        });
    }
    return _agreeButton;
}

- (UIButton *)agreementButton
{
    if (!_agreementButton) {
        _agreementButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(45,155, 160, 40)];
            [button setTitle:@"我已经阅读并同意《协议》" forState:UIControlStateNormal];
            [button setTitleColor:UIColorFromHex(0x696969, 1) forState:UIControlStateNormal];
            [button.titleLabel setFont:UIFontPingFangRegular(13)];
            
            button;
        });
    }
    return _agreementButton;
}

- (UIButton *)submitButton
{
    if (!_submitButton) {
        _submitButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button.layer setMasksToBounds:YES];
            [button.layer setCornerRadius:5];
            [button setFrame:CGRectMake(15, 230, kScreenWidth -30, 40)];
            
            [button setBackgroundImage:[UIImage imageWithColor:kMainColor size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
            [button setTitle:@"提交" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button.titleLabel setFont:UIFontPingFangRegular(15)];
            
            [button addTarget:self action:@selector(selectSubmitButton:) forControlEvents:UIControlEventTouchUpInside];
            
            button;
        });
    }
    return _submitButton;
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark Button Action
- (IBAction)selectAgreeButton:(UIButton *)sender
{
    [sender setSelected:!sender.selected];
}

- (IBAction)selectSendCodeButton:(id)sender
{
    if (_phoneTextField.text.length ==11) {
        [self requestSendVirficationCode];
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请填写正确的电话号码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
    }
}

- (IBAction)selectSubmitButton:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancelAction];
    if (_phoneTextField.text.length != 11) {
        [alertController setMessage:@"请填写正确的电话号码"];
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
    }else if (_passwordTextField.text.length<6){
        [alertController setMessage:@"密码不得少于6位"];
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
    }else if (_verificationCodeTextField.text.length != 6){
        [alertController setMessage:@"请填写您收到的短信验证码"];
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
    }else if (!_agreeButton.selected){
        [alertController setMessage:@"请填阅读并同意用户注册协议"];
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
    }else{
        [self requestRegister];
    }
}

#pragma mark Request Data
- (void)requestSendVirficationCode
{
    //组装请求字典
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          _phoneTextField.text,@"phone",
                          nil];
    //发送请求
    [self showHudInView:self.view hint:nil];
    [DDPBLL requestWithURL: DEF_URL_SendVirficationCode  Dict:dict result:^(NSDictionary *responseDict)
     {
         [self hideHud];
         if (responseDict == nil) {
             [self showHint:@"处理失败，请稍后再试"];
             return;
         }
         if ([[responseDict objectForKey:@"status"] integerValue]==0) {
             [self showHint:responseDict[@"msg"]];
             [_sendCodeButton setEnabled:NO];
             _interval = 60;
             _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeCountDown:) userInfo:nil repeats:YES];
             [_timer fire];
         }else{
             [self showHint:responseDict[@"msg"]];
         }
     }];
}

- (void)requestRegister
{
    NSDictionary *dict = @{@"phone":_phoneTextField.text,@"password":_passwordTextField.text,@"code":_verificationCodeTextField.text};
    
    [self showHudInView:self.view hint:nil];
    [DDPBLL requestWithURL:DEF_URL_Register Dict:dict result:^(NSDictionary *responseDict) {
        [self hideHud];
        if (responseDict == nil) {
            [self showHint:@"处理失败，请稍后再试"];
            return ;
        }
        if ([[responseDict objectForKey:@"status"] integerValue]==0) {
            [self showHint:responseDict[@"msg"]];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showHint:responseDict[@"msg"]];
        }
    }];
}

#pragma mark Timer
- (void)timeCountDown:(NSTimer *)sender
{
    if (_interval !=0) {
        [_sendCodeButton setTitle:[NSString stringWithFormat:@"%ld秒后重新发送",_interval--] forState:UIControlStateDisabled];
    }else{
        [_sendCodeButton setEnabled:YES];
        [_sendCodeButton setTitle:@"重新发送" forState:UIControlStateNormal];
        [sender invalidate];
    }
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
