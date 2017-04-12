//
//  FavorablePayViewController.m
//  ShareBuyUser
//
//  Created by soldier on 16/8/17.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "FavorablePayViewController.h"
#import "FavorableOrderPayViewController.h"

@interface FavorablePayViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UITextField *moneyTextField;
@property (nonatomic, strong) UILabel *favorableInfoLabel;
@property (nonatomic, strong) UILabel *realPriceLabel;
@property (nonatomic, strong) UIButton *payButton;

@property (nonatomic, strong) NSString *benefitStr;
@property (nonatomic, strong) NSString *businessID;

@end

@implementation FavorablePayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"优惠付款"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:self.headImgView];
    NSArray *titleArray = @[@"支付金额:",@"优惠信息:",@"实付金额:"];
    for (int i = 0; i< [titleArray count]; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150+i*50, 100, 50)];
        [label setTextColor:UIColorFromHex(0x3c3c3c, 1)];
        [label setFont:UIFontPingFangMedium(15.0f)];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setText:titleArray[i]];
        [self.view addSubview:label];
    }
    [self.view addSubview:self.moneyTextField];
    [self.view addSubview:self.favorableInfoLabel];
    [self.view addSubview:self.realPriceLabel];
    [self.view addSubview:self.payButton];
    
    NSDictionary *dict = @{@"businessid":self.storeId};
    [self getBusinessMessageRequestWithDict:dict];
}

- (UIImageView *)headImgView
{
    if (!_headImgView) {
        _headImgView = ({
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 140)];
            [imageView setImageWithURL:[NSURL URLWithString:self.imgUrlStr] placeholderImage:[UIImage imageNamed:@"product_placeholder"]];
            
            imageView;
        });
    }
    return _headImgView;
}

- (UITextField *)moneyTextField
{
    if (!_moneyTextField) {
        _moneyTextField = ({
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 150+7, kScreenWidth-120, 35)];
            [textField setDelegate:self];
            [textField setBorderStyle:UITextBorderStyleRoundedRect];
            [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
            [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            [textField setReturnKeyType:UIReturnKeyDone];
            [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
            [textField setTextColor:UIColorFromHex(0x696969, 1)];
            [textField setFont:UIFontPingFangRegular(15)];
            [textField setKeyboardType:UIKeyboardTypeDecimalPad];
            [textField setPlaceholder:@"请输入账号支付金额"];
            
            textField;
        });
    }
    return _moneyTextField;
}

- (UILabel *)favorableInfoLabel
{
    if (!_favorableInfoLabel) {
        _favorableInfoLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 200, kScreenWidth-120, 50)];
            [label setTextColor:UIColorFromHex(0x3c3c3c, 1)];
            [label setFont:UIFontPingFangMedium(15.0f)];
            
            label;
        });
    }
    return _favorableInfoLabel;
}

- (UILabel *)realPriceLabel
{
    if (!_realPriceLabel) {
        _realPriceLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 250, kScreenWidth-120, 50)];
            [label setTextColor:kMainColor];
            [label setFont:UIFontPingFangMedium(15.0f)];
            
            label;
        });
    }
    return _realPriceLabel;
}

- (UIButton *)payButton
{
    if (!_payButton) {
        _payButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(20, kScreenHeight-kNavigationBarHight-70, kScreenWidth-40, 40)];
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 5.0f;
            [button setTitle:@"去支付" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button.titleLabel setFont:UIFontPingFangRegular(15)];
            [button setBackgroundImage:[UIImage imageWithColor:kMainColor size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(clickPaymentBtn:) forControlEvents:UIControlEventTouchUpInside];

            button;
        });
    }
    return _payButton;
}

#pragma mark - UIButton Action
- (void)clickPaymentBtn:(UIButton *)sender
{
    NSLog(@"优惠支付");
    if ([_moneyTextField.text length] == 0) {
        [self showHint:@"请输入支付金额" yOffset:-250];
        return;
    }
    NSDictionary *dic = @{@"businessid":_businessID,@"token":[UserModel shareUserModel].userToken,@"price":_moneyTextField.text,@"payprice":[NSString stringWithFormat:@"%.2f",[_moneyTextField.text floatValue] * [_benefitStr floatValue]]};
    [self insertOrderBusinessRequestWithDict:dic];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"%@",string);
    NSString * moneyStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    [_realPriceLabel setText:[NSString stringWithFormat:@"￥%.2f",[moneyStr floatValue] * [_benefitStr floatValue]]];
    return YES;
}


#pragma mark - 
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_moneyTextField resignFirstResponder];
}

#pragma mark - NetWorking 
//优惠付款
- (void)getBusinessMessageRequestWithDict:(NSDictionary *)dict
{
    [self showHudInView:self.view hint:nil];
    [DDPBLL requestWithURL:DEF_URL_FindBusiMess  Dict:dict result:^(NSDictionary *responseDict) {
        [self hideHud];
        NSLog(@"%@",responseDict);
        if (responseDict == nil) {
            return ;
        }
        if ([[responseDict objectForKey:@"status"] integerValue] == 0) {
            if ([responseDict[@"data"][@"benefit"] floatValue] == 0) {
                [_favorableInfoLabel setText:@"没有折扣"];
                _benefitStr = @"1";
            }else
            {
                [_favorableInfoLabel setText:[NSString stringWithFormat:@"打%.1f折",[responseDict[@"data"][@"benefit"] floatValue] *10]];
                _benefitStr = [NSString stringWithFormat:@"%@",responseDict[@"data"][@"benefit"]];
            }
            _businessID = [NSString stringWithFormat:@"%@",responseDict[@"data"][@"businessid"]];
        }
        else{
            [self showHint:responseDict[@"msg"]];
        }
    }];
}

//店铺支付生成订单
- (void)insertOrderBusinessRequestWithDict:(NSDictionary *)dict
{
    [self showHudInView:self.view hint:nil];
    [DDPBLL requestWithURL:DEF_URL_InsertOrderBusi  Dict:dict result:^(NSDictionary *responseDict) {
        [self hideHud];
        NSLog(@"%@",responseDict);
        if (responseDict == nil) {
            return ;
        }
        if ([[responseDict objectForKey:@"status"] integerValue] == 0) {
            NSLog(@"店铺支付生成订单成功");
            //跳转到订单支付页面
            FavorableOrderPayViewController *favorableOrderPayVC = [[FavorableOrderPayViewController alloc] init];
            favorableOrderPayVC.isStore = YES;
            [favorableOrderPayVC setTitle:@"支付"];
            favorableOrderPayVC.orderID = responseDict[@"data"];
            favorableOrderPayVC.orderPrice = [NSString stringWithFormat:@"%.2f",[_moneyTextField.text floatValue] * [_benefitStr floatValue]];
            [self.navigationController pushViewController:favorableOrderPayVC animated:YES];
        }
        else{
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
