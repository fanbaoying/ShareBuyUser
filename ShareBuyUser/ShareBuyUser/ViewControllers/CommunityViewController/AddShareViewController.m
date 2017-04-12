//
//  AddShareViewController.m
//  ShareBuyUser
//
//  Created by 刘兵 on 16/8/12.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "AddShareViewController.h"

@interface AddShareViewController ()<UITextViewDelegate>
{
    UITextView *myTextView;
    UILabel *contentLabel;
    UITextView *titleTextView;
    UIView *lineView;
}

@end

@implementation AddShareViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"分享";
    self.view.backgroundColor = UIColorFromHex(0xffffff, 1);
    
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [myTextView resignFirstResponder];
}

- (void)createUI {
//    CGRect rect = [@"卡积分快乐大脚发酒疯卡机了看法发卡机福利卡尽快发健康了来房间爱咖啡按键" boundingRectWithSize:CGSizeMake(kScreenWidth - 20, 1000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:UIFontPingFangMedium(14)} context:nil];
//    contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, rect.size.height)];
//    contentLabel.text = @"卡积分快乐大脚发酒疯卡机了看法发卡机福利卡尽快发健康了来房间爱咖啡按键";
//    contentLabel.numberOfLines = 0;
//    contentLabel.font = UIFontPingFangMedium(14);
//    [self.view addSubview:contentLabel];
    
    titleTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, 30)];
    titleTextView.text = @"请输入分享标题";
    titleTextView.textColor = UIColorFromHex(0x9b9b9b, 1);
    titleTextView.font = UIFontPingFangMedium(14);
    titleTextView.delegate = self;
    [self.view addSubview:titleTextView];
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(titleTextView.frame)+10, kScreenWidth - 20, 0.5)];
    lineView.backgroundColor = UIColorFromHex(0xbcbcbc, 1);
    [self.view addSubview:lineView];
    
    myTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lineView.frame)+10, kScreenWidth - 20, 120)];
    myTextView.text = @"请输入分享描述";
    myTextView.font = UIFontPingFangMedium(14);
    myTextView.textColor = UIColorFromHex(0x9b9b9b, 1);
    myTextView.backgroundColor = UIColorFromHex(0xf2f2f2, 1);
    myTextView.layer.cornerRadius = 10;
    myTextView.layer.masksToBounds = YES;
    myTextView.delegate = self;
    [self.view addSubview:myTextView];
    
    UIButton *bottomBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, kScreenHeight - 70 - 64, kScreenWidth - 30, 40)];
    [bottomBtn setTitle:@"分享" forState:UIControlStateNormal];
    [bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bottomBtn.backgroundColor = UIColorFromHex(0xfe5e3a, 1);
    bottomBtn.titleLabel.font = UIFontPingFangMedium(15);
    [bottomBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    bottomBtn.layer.cornerRadius = 5;
    bottomBtn.layer.masksToBounds = YES;
    [self.view addSubview:bottomBtn];
};

- (void)share {
    NSLog(@"分享");
    // type  0小订单1大订单
    if ([_orderType integerValue] == 0) {
        NSDictionary *dic = @{@"token":[UserModel shareUserModel].userToken,@"title":titleTextView.text,@"content":myTextView.text,@"oid":_orderID,@"type":_orderType};
        [self addTopicInfoRequestWithDict:dic];
    }else
    {
        NSDictionary *dic = @{@"token":[UserModel shareUserModel].userToken,@"title":titleTextView.text,@"content":myTextView.text,@"orderid":_orderID,@"type":_orderType};
        [self addTopicInfoRequestWithDict:dic];
    }
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    textView.text = @"";
    textView.textColor = [UIColor blackColor];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length == 0) {
        textView.textColor = UIColorFromHex(0x9b9b9b, 1);
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    if ([textView isEqual:titleTextView]) {
        CGRect rect = [titleTextView.text boundingRectWithSize:CGSizeMake(kScreenWidth - 20, 1000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:UIFontPingFangMedium(14)} context:nil];
        titleTextView.frame = CGRectMake(10, 10, kScreenWidth - 20, rect.size.height+20);
        lineView.frame = CGRectMake(10, CGRectGetMaxY(titleTextView.frame)+10, kScreenWidth - 20, 0.5);
        myTextView.frame = CGRectMake(10, CGRectGetMaxY(lineView.frame)+10, kScreenWidth - 20, 120);
    }
    return YES;
}

#pragma mark - Networking
//社区添加帖子
- (void)addTopicInfoRequestWithDict:(NSDictionary *)dict
{
    [self showHudInView:self.view hint:nil];
    [DDPBLL requestWithURL:DEF_URL_AddTopicInfo  Dict:dict result:^(NSDictionary *responseDict) {
        [self hideHud];
        NSLog(@"%@",responseDict);
        if (responseDict == nil) {
            return ;
        }
        if ([[responseDict objectForKey:@"status"] integerValue] == 0) {
            NSLog(@"社区添加帖子成功");
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else{
            [self showHint:responseDict[@"msg"]];
        }
    }];
}


@end
