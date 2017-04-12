//
//  DirectMessagesViewController.m
//  ShareBuyUser
//
//  Created by 刘兵 on 16/8/12.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "DirectMessagesViewController.h"
#import "AddShareViewController.h"

@interface DirectMessagesViewController ()<UITextViewDelegate>
{
    UITextView *textView;
}

@end

@implementation DirectMessagesViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"私信Ta";
    
    [self addTextView];
    [self addBottomBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action 

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [textView resignFirstResponder];
}

- (void)addTextView {
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 140)];
    backView.backgroundColor = [UIColor whiteColor];
    
    textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, 120)];
    textView.backgroundColor = UIColorFromHex(0xf2f2f2, 1);
    textView.font = UIFontPingFangMedium(14);
    textView.text = @"说点什么呢...";
    textView.textColor = UIColorFromHex(0x9b9b9b, 1);
    textView.delegate = self;
    textView.layer.cornerRadius = 10;
    textView.layer.masksToBounds = YES;
    [backView addSubview:textView];
    
    [self.view addSubview:backView];
}

- (void)addBottomBtn {
    UIButton *bottomBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, kScreenHeight - 70 - 64, kScreenWidth - 30, 40)];
    [bottomBtn setTitle:@"发送" forState:UIControlStateNormal];
    [bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bottomBtn.backgroundColor = UIColorFromHex(0xfe5e3a, 1);
    bottomBtn.titleLabel.font = UIFontPingFangMedium(15);
    [bottomBtn addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    bottomBtn.layer.cornerRadius = 5;
    bottomBtn.layer.masksToBounds = YES;
    [self.view addSubview:bottomBtn];
}

- (void)send {
    NSLog(@"发送");
    if (![UserModel ifLogin]) {
        [self presentViewController:[[BaseNavController alloc] initWithRootViewController:[LoginViewController new]] animated:YES completion:^{
        }];
        return;
    }
    NSDictionary *dic = @{@"token":[UserModel shareUserModel].userToken,@"recipientid":_recipientID,@"content":textView.text};
    [self addUserPrivateLetterWithDict:dic];
//    [self.navigationController pushViewController:[AddShareViewController new] animated:YES];
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView1{
    textView.text = @"";
    textView.textColor = [UIColor blackColor];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView1 {
    if (textView.text.length == 0) {
        textView.text = @"说点什么呢...";
        textView.textColor = UIColorFromHex(0x9b9b9b, 1);
    }
}

- (BOOL)textView:(UITextView *)textView1 shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}

#pragma mark - Networking
//用户私信新增 
- (void)addUserPrivateLetterWithDict:(NSDictionary *)dict
{
    [self showHudInView:self.view hint:nil];
    [DDPBLL requestWithURL:DEF_URL_AddUserPrivateLetter  Dict:dict result:^(NSDictionary *responseDict) {
        [self hideHud];
        NSLog(@"%@",responseDict);
        if (responseDict == nil) {
            return ;
        }
        if ([[responseDict objectForKey:@"status"] integerValue] == 0) {
            NSLog(@"添加私信成功");
        }
        else{
            [self showHint:responseDict[@"msg"]];
        }
    }];
}

@end
