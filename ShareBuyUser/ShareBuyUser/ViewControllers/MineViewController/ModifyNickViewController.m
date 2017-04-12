//
//  ModifyNickViewController.m
//  ShareBuyUser
//
//  Created by soldier on 16/8/24.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "ModifyNickViewController.h"

@interface ModifyNickViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *nickTextField;
@property (nonatomic, strong) UIBarButtonItem *confirmBtnItem;

@end

@implementation ModifyNickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改昵称";
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 70)];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:bgView];
    
    [bgView addSubview:self.nickTextField];
    self.navigationItem.rightBarButtonItem = self.confirmBtnItem;
}

#pragma mark - Get Method
- (UITextField *)nickTextField
{
    if (!_nickTextField) {
        _nickTextField = ({
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 15, kScreenWidth-40, 35)];
            [textField setDelegate:self];
            [textField setPlaceholder:@"请输入昵称"];
            [textField setBorderStyle:UITextBorderStyleRoundedRect];
            [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
            [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            [textField setReturnKeyType:UIReturnKeyDone];
            [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
            [textField setTextColor:UIColorFromHex(0x696969, 1)];
            [textField setFont:UIFontPingFangRegular(15)];
            
            textField;
        });
    }
    return _nickTextField;
}

- (UIBarButtonItem *)confirmBtnItem
{
    if (!_confirmBtnItem) {
        _confirmBtnItem = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(0, 0, 40, 20)];
            [button setTitle:@"确认" forState:UIControlStateNormal];
            button.titleLabel.font = UIFontPingFangRegular(15.0f);
            [button addTarget:self action:@selector(clickConfirmNick) forControlEvents:UIControlEventTouchUpInside];
//            UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(clickConfirmNick)];
            UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:button];
            
            barBtnItem;
        });
    }
    return _confirmBtnItem;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_nickTextField resignFirstResponder];
    return YES;
}

#pragma mark - UIButton Action
- (void)clickConfirmNick
{
    NSLog(@"昵称确认");
    if (_nickTextField.text.length == 0) {
        [self showHint:@"请输入昵称" yOffset:-250];
        return;
    }
    NSDictionary *requestDic = @{@"token":[UserModel shareUserModel].userToken,@"nickname":_nickTextField.text};
    [self updateUserNicknameWithDict:requestDic];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_nickTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - network

- (void)updateUserNicknameWithDict:(NSDictionary *)dict {
    [DDPBLL requestWithURL:DEF_URL_UpdateUserNickName Dict:dict result:^(NSDictionary *responseDict) {
        if (responseDict == nil) {
            return ;
        }
        if ([responseDict[@"state"] integerValue] == 0) {
            [UserModel shareUserModel].userNick = _nickTextField.text;
            [self.navigationController popViewControllerAnimated:YES];
        }
        [self showHint:responseDict[@"msg"] yOffset:-250];
    }];
}

@end
