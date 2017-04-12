//
//  FavorableOrderPayViewController.m
//  ShareBuyUser
//
//  Created by soldier on 16/8/30.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "FavorableOrderPayViewController.h"
#import "OrderResultViewController.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WeChatPayMethodsUtils.h"

@interface FavorableOrderPayViewController ()
{
    WeChatPayMethodsUtils *wechatPayMethod;
}

@property(nonatomic)UILabel *orderNoLabel;
@property(nonatomic)UILabel *priceLabel;

@property(nonatomic)UIButton *balancePayButton;
@property(nonatomic)UIButton *wechatPayButton;
@property(nonatomic)UIButton *aliPayButton;
@property(nonatomic)UIButton *unionPayButton;

@end

@implementation FavorableOrderPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"支付"];
    [self customView];
    
    wechatPayMethod = [[WeChatPayMethodsUtils alloc] init];
}

#pragma mark Custom View
- (void)customView
{
    UIView *bgView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 90)];
        [view setBackgroundColor:[UIColor whiteColor]];
        UILabel *orderNoLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 45)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextAlignment:NSTextAlignmentLeft];
            [label setTextColor:UIColorFromHex(0x696969, 1)];
            [label setFont:UIFontPingFangRegular(15)];
            [label setText:@"订单号："];
            label;
        });
        [view addSubview:orderNoLabel];
        [view addSubview:self.orderNoLabel];
        
        UIView *lineView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 44.75, kScreenWidth-20, 0.5)];
            [view setBackgroundColor:UIColorFromHex(0xbbbbbb, 1)];
            view;
        });
        [view addSubview:lineView];
        
        UILabel *priceLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, 100, 45)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextAlignment:NSTextAlignmentLeft];
            [label setTextColor:UIColorFromHex(0x696969, 1)];
            [label setFont:UIFontPingFangRegular(15)];
            [label setText:@"应付金额："];
            label;
        });
        [view addSubview:priceLabel];
        [view addSubview:self.priceLabel];
        
        view;
    });
    [self.view addSubview:bgView];
    
    UIView *lineView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 209.75, kScreenWidth, 0.5)];
        [view setBackgroundColor:UIColorFromHex(0xbbbbbb, 1)];
        view;
    });
    [self.view addSubview:lineView];
    
    UILabel *payLabel = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth -100)/2, 200, 100, 20)];
        [label setBackgroundColor:UIColorFromHex(0xf6f6f6, 1)];
        [label setTextColor:UIColorFromHex(0x999999, 1)];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:UIFontPingFangRegular(13)];
        [label setText:@"在线支付选择"];
        label;
    });
    [self.view addSubview:payLabel];
    
    [self.view addSubview:self.wechatPayButton];
    [self.view addSubview:self.aliPayButton];
    [self.view addSubview:self.unionPayButton];
    
}

- (UILabel *)orderNoLabel
{
    if (!_orderNoLabel) {
        _orderNoLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, kScreenWidth-120, 45)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextAlignment:NSTextAlignmentRight];
            [label setTextColor:UIColorFromHex(0x999999, 1)];
            [label setFont:UIFontPingFangRegular(15)];
            [label setText:_orderID];
            
            label;
        });
    }
    return _orderNoLabel;
}

- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(110, 45, kScreenWidth-120, 45)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextAlignment:NSTextAlignmentRight];
            [label setTextColor:kMainColor];
            [label setFont:UIFontPingFangRegular(15)];
            [label setText:_orderPrice];
            
            label;
        });
    }
    return _priceLabel;
}

- (UIButton *)wechatPayButton
{
    if (!_wechatPayButton) {
        _wechatPayButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(15, 300, kScreenWidth - 30, 35)];
            [button setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(0x8ec220, 1) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"wechat_pay_button_normal"] forState:UIControlStateNormal];
            [button setTitle:@"　微信支付　" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button.titleLabel setFont:UIFontPingFangRegular(15)];
            [button addTarget:self action:@selector(wechatPayClick) forControlEvents:UIControlEventTouchUpInside];
            [button.layer setMasksToBounds:YES];
            [button.layer setCornerRadius:5];
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 50)];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 50, 0, 0)];
            
            button;
        });
    }
    return _wechatPayButton;
}

- (UIButton *)aliPayButton
{
    if (!_aliPayButton) {
        _aliPayButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(15, 350, kScreenWidth - 30, 35)];
            [button setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(0x00b7eb, 1) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"ali_pay_button_normal"] forState:UIControlStateNormal];
            [button setTitle:@" 支付宝支付  " forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button.titleLabel setFont:UIFontPingFangRegular(15)];

            [button addTarget:self action:@selector(clickAliPayBtn:) forControlEvents:UIControlEventTouchUpInside];

            [button.layer setMasksToBounds:YES];
            [button.layer setCornerRadius:5];
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 50)];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 50, 0, 0)];
            
            button;
        });
    }
    return _aliPayButton;
}

- (UIButton *)unionPayButton
{
    if (!_unionPayButton) {
        _unionPayButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(15, 400, kScreenWidth - 30, 35)];
            [button setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(0x0977ce, 1) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"ali_pay_button_normal"] forState:UIControlStateNormal];
            [button setTitle:@"　银联支付　" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button.titleLabel setFont:UIFontPingFangRegular(15)];
            [button addTarget:self action:@selector(unionPayClick) forControlEvents:UIControlEventTouchUpInside];
            [button.layer setMasksToBounds:YES];
            [button.layer setCornerRadius:5];
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 50)];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 50, 0, 0)];
            
            button;
        });
    }
    return _unionPayButton;
}

#pragma mark - UIButton Action
- (void)clickAliPayBtn:(UIButton *)button
{
    NSLog(@"支付宝付款");
    if (_isStore) {
        NSLog(@"店铺优惠付款");
        NSDictionary *dic = @{@"token":[UserModel shareUserModel].userToken,@"orderid":_orderID};
        [self getBusinessOrderPayNotifyUrlRequestWithDict:dic];
    }else
    {
        NSDictionary *dic = @{@"token":[UserModel shareUserModel].userToken,@"orderid":_orderDic[@"oid"]};
        [self getScanOrderPayNotifyUrlRequestWithDict:dic];
    }
}

- (void)clickWeChatBtn:(UIButton *)button
{
    NSLog(@"微信付款");
    if (_isStore) {
        NSLog(@"店铺优惠付款");
        NSDictionary *dic = @{@"token":[UserModel shareUserModel].userToken,@"orderid":_orderID};
        [self getBusinessWeChatOrderIdRequestWithDict:dic];
    }else
    {
        NSDictionary *dic = @{@"token":[UserModel shareUserModel].userToken,@"orderid":_orderDic[@"oid"]};
        [self getScanWeChatOrderIdRequestWithDict:dic];
    }
}

- (void)doAlipayPayWithNotifyUrl:(NSString *)notifyUrl
{
    NSString *partner = PartnerID;
    NSString *seller = SellerID;
    NSString *privateKey = PartnerPrivKey;
    
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    if (_isStore) {
        order.tradeNO = _orderID;  //订单ID（由商家自行制定）
    }else
    {
        order.tradeNO = _orderDic[@"oid"];  //订单ID（由商家自行制定）
    }
    order.productName = @"商品标题"; //商品标题
    order.productDescription = @"商品描述"; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",[_orderPrice floatValue]]; //商品价格
    order.notifyURL = notifyUrl; //回调URL
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = kAliPayURLScheme;
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            NSLog(@"%@",resultDic[@"memo"]);
            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]&&([resultDic[@"result"] rangeOfString:@"true"].location != NSNotFound)) {
                NSLog(@"支付成功");
                
                OrderResultViewController *orderResultVC = [[OrderResultViewController alloc] init];
                orderResultVC.orderDict = [NSMutableDictionary dictionaryWithDictionary:_orderDic];
//                orderResultVC.navigationItem.rightBarButtonItem = orderResultVC.shareBarBtnItem;
                orderResultVC.paymentStr = @"支付宝支付";
                if (_isStore) {
                    orderResultVC.orderPrice = self.orderPrice;
                    orderResultVC.orderid = self.orderID;
                }
                [self.navigationController pushViewController:orderResultVC animated:YES];
                
            }else{
                NSLog(@"支付失败");
                [self showHint:resultDic[@"memo"] yOffset:-250];
            }
        }];
    }
}

#pragma mark - Networking
//支付宝订单支付获取回调地址 (扫码)
- (void)getScanOrderPayNotifyUrlRequestWithDict:(NSDictionary *)dict
{
    [self showHudInView:self.view hint:nil];
    [DDPBLL requestWithURL:DEF_URL_GetScanOrderPayNotifyUrl  Dict:dict result:^(NSDictionary *responseDict) {
        [self hideHud];
        NSLog(@"%@",responseDict);
        if (responseDict == nil) {
            [self showHint:@"处理失败，请稍后再试"];
            return ;
        }
        if ([[responseDict objectForKey:@"status"] integerValue] == 0) {
            NSLog(@"获取支付宝支付获取回调地址成功");
            
            [self doAlipayPayWithNotifyUrl:responseDict[@"data"][@"notifyurl"]];
        }else{
            [self showHint:responseDict[@"msg"]];
        }
    }];
    
}

//支付宝支付获取回调地址(优惠付)  
- (void)getBusinessOrderPayNotifyUrlRequestWithDict:(NSDictionary *)dict
{
    [self showHudInView:self.view hint:nil];
    [DDPBLL requestWithURL:DEF_URL_BusinessOrderPayNotifyUrl  Dict:dict result:^(NSDictionary *responseDict) {
        [self hideHud];
        NSLog(@"%@",responseDict);
        if (responseDict == nil) {
            [self showHint:@"处理失败，请稍后再试"];
            return ;
        }
        if ([[responseDict objectForKey:@"status"] integerValue] == 0) {
            NSLog(@"获取支付宝支付获取回调地址成功");
            
            [self doAlipayPayWithNotifyUrl:responseDict[@"data"][@"notifyurl"]];
        }else{
            [self showHint:responseDict[@"msg"]];
        }
    }];
}

//微信订单支付获取预支付交易会话标识(优惠付) 
- (void)getBusinessWeChatOrderIdRequestWithDict:(NSDictionary *)dict
{
    [self showHudInView:self.view hint:nil];
    [DDPBLL requestWithURL:DEF_URL_BusinessWeChatOrderID  Dict:dict result:^(NSDictionary *responseDict) {
        [self hideHud];
        NSLog(@"%@",responseDict);
        if (responseDict == nil) {
            [self showHint:@"处理失败，请稍后再试"];
            return ;
        }
        if ([[responseDict objectForKey:@"status"] integerValue] == 0) {
            NSLog(@"获取微信订单支付获取预支付交易会话标识成功");
            
            [wechatPayMethod wechatPaymentWithPrepayid:responseDict[@"data"][0][@"prepayId"]];
        }else{
            [self showHint:responseDict[@"msg"]];
        }
    }];
}

//微信订单支付获取预支付交易会话标识(扫码)
- (void)getScanWeChatOrderIdRequestWithDict:(NSDictionary *)dict
{
    [self showHudInView:self.view hint:nil];
    [DDPBLL requestWithURL:DEF_URL_GetScanWeChatOrderId  Dict:dict result:^(NSDictionary *responseDict) {
        [self hideHud];
        NSLog(@"%@",responseDict);
        if (responseDict == nil) {
            [self showHint:@"处理失败，请稍后再试"];
            return ;
        }
        if ([[responseDict objectForKey:@"status"] integerValue] == 0) {
            NSLog(@"获取微信订单支付获取预支付交易会话标识成功");
            
            [wechatPayMethod wechatPaymentWithPrepayid:responseDict[@"data"][0][@"prepayId"]];
        }else{
            [self showHint:responseDict[@"msg"]];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
