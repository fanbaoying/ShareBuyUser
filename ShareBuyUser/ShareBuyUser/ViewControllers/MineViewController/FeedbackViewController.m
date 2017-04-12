//
//  FeedbackViewController.m
//  ShareBuyUser
//
//  Created by Marx on 16/8/22.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()<UITextViewDelegate>

@property(nonatomic)UITextView *feedbackTextView;

@property(nonatomic)UIButton *submitButton;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"意见反馈"];
    [self customView];
}

#pragma mark Custom View
- (void)customView
{
    UIView *bgView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 5, kScreenWidth, 135)];
        [view setBackgroundColor:[UIColor whiteColor]];
        [view addSubview:self.feedbackTextView];
        view;
    });
    [self.view addSubview:bgView];
    
    [self.view addSubview:self.submitButton];
    
}

- (UITextView *)feedbackTextView
{
    if (!_feedbackTextView) {
        _feedbackTextView = ({
            UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 15, kScreenWidth-20, 105)];
            [textView setDelegate:self];
            
            [textView.layer setMasksToBounds:YES];
            [textView.layer setCornerRadius:5];
            [textView setBackgroundColor:UIColorFromHex(0xf6f6f6, 1)];
            [textView setTextColor:UIColorFromHex(0x999999, 1)];
            [textView setFont:UIFontPingFangRegular(15)];
            [textView setText:@"请输入您的意见"];
            textView;
        });
    }
    return _feedbackTextView;
}

- (UIButton *)submitButton
{
    if (!_submitButton) {
        _submitButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(15, 220, kScreenWidth-30, 35)];
            [button.layer setMasksToBounds:YES];
            [button.layer setCornerRadius:5];
            [button setBackgroundImage:[UIImage imageWithColor:kMainColor size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
            [button setTitle:@"提交" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(selectSubmitButton:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _submitButton;
}

#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请输入您的意见"]) {
        [textView setText:@""];
        [textView setTextColor:UIColorFromHex(0x696969, 1)];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length <=0) {
        [textView setText:@"请输入您的意见"];
        [textView setTextColor:UIColorFromHex(0x999999, 1)];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark Button Action
- (IBAction)selectSubmitButton:(id)sender
{
    [_feedbackTextView resignFirstResponder];
    if ([_feedbackTextView.text isEqualToString:@"请输入您的意见"]) {
        
    }else{
        if (_feedbackTextView.text.length>0) {
            [self requestFeedbackData];
        }
    }
}

#pragma mark Request Data
- (void)requestFeedbackData
{
    NSDictionary *dict = @{@"token":[UserModel shareUserModel].userToken,@"content":_feedbackTextView.text};
    
    [self showHudInView:self.view hint:nil];
    [DDPBLL requestWithURL:DEF_URL_Feedback Dict:dict result:^(NSDictionary *responseDict) {
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
