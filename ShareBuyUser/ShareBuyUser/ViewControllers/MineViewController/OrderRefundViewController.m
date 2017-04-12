//
//  OrderRefundViewController.m
//  ShareBuyUser
//
//  Created by Marx on 16/8/16.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "OrderRefundViewController.h"

@interface OrderRefundViewController () <UITextViewDelegate>

@property(nonatomic)UILabel *priceLabel;
@property(nonatomic)UITextView *reasonTextView;
@property(nonatomic)UIBarButtonItem *submitBarBtnItem;

@end

@implementation OrderRefundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"申请售后/退款"];
    [self customView];
}

#pragma mark Custom View
- (void)customView
{
    UIView *bgView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 5, kScreenWidth, 180)];
        [view setBackgroundColor:[UIColor whiteColor]];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, (kScreenWidth-30)/2, 45)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:UIColorFromHex(0x696969, 1)];
        [label setFont:UIFontPingFangRegular(15)];
        [label setTextAlignment:NSTextAlignmentLeft];
        [label setText:@"退款金额："];
        
        [view addSubview:label];
        [view addSubview:self.priceLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 44.75, kScreenWidth-20, 0.5)];
        [lineView setBackgroundColor:UIColorFromHex(0xbbbbbb, 1)];
        [view addSubview:lineView];
        
        [view addSubview:self.reasonTextView];
        
        view;
    });
    [self.view addSubview:bgView];
    
    self.navigationItem.rightBarButtonItem = self.submitBarBtnItem;
}

- (UIBarButtonItem *)submitBarBtnItem
{
    if (!_submitBarBtnItem) {
        _submitBarBtnItem = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(0, 0, 40, 20)];
            [button setTitle:@"提交" forState:UIControlStateNormal];
            button.titleLabel.font = UIFontPingFangMedium(14.0f);
            [button addTarget:self action:@selector(clickRefund:) forControlEvents:UIControlEventTouchUpInside];
            
            UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:button];
            barBtnItem;
        });
    }
    return _submitBarBtnItem;
}


- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2, 0, (kScreenWidth-30)/2, 45)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextColor:kMainColor];
            [label setFont:UIFontPingFangRegular(15)];
            [label setTextAlignment:NSTextAlignmentRight];
            [label setText:[NSString stringWithFormat:@"¥%.2f",[_orderDic[@"payprice"] floatValue]]];
            
            label;
        });
    }
    return _priceLabel;
}

- (UITextView *)reasonTextView
{
    if (!_reasonTextView) {
        _reasonTextView = ({
            UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 60, kScreenWidth-20, 105)];
            [textView setDelegate:self];
            [textView.layer setMasksToBounds:YES];
            [textView.layer setCornerRadius:10];
            [textView setBackgroundColor:UIColorFromHex(0xf6f6f6, 1)];
            [textView setReturnKeyType:UIReturnKeyDone];
            [textView setFont:UIFontPingFangRegular(15)];
            [textView setAutocorrectionType:UITextAutocorrectionTypeNo];
            [textView setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            textView;
        });
    }
    
    return _reasonTextView;
}

#pragma mark - UIButton Action
- (void)clickRefund:(UIButton *)button
{
    NSLog(@"申请退款");
    NSDictionary *dic = @{@"token":[UserModel shareUserModel].userToken,@"oid":_orderDic[@"oid"],@"reason":_reasonTextView.text};
    [self refundOrderRequestWithDict:dic];
}

#pragma mark - NetWorking
//申请退款   
- (void)refundOrderRequestWithDict:(NSDictionary *)dict
{
    [self showHudInView:self.view hint:nil];
    [DDPBLL requestWithURL:DEF_URL_RefundOrder  Dict:dict result:^(NSDictionary *responseDict) {
        [self hideHud];
        NSLog(@"%@",responseDict);
        if (responseDict == nil) {
            [self showHint:@"处理失败，请稍后再试"];
            return ;
        }
        if ([[responseDict objectForKey:@"status"] integerValue]==0) {
            NSLog(@"申请退款成功");
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showHint:responseDict[@"msg"]];
        }
    }];
}

#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请输入"]) {
        [textView setText:@""];
        [textView setTextColor:UIColorFromHex(0x696969, 1)];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length ==0) {
        [textView setText:@"请输入"];
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_reasonTextView resignFirstResponder];
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
