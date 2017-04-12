//
//  ScanResultViewController.m
//  ShareBuyUser
//
//  Created by soldier on 16/8/10.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "ScanResultViewController.h"
#import "UIImage+Color.h"
#import "OrderDetailViewController.h"
#import "FavorableOrderPayViewController.h"

@interface ScanResultViewController ()

@property (nonatomic, strong) UIImageView *logoImgView;          //商家logo
@property (nonatomic, strong) UILabel *storeNameLabel;            //商家名称
@property (nonatomic, strong) UILabel *originalPriceLabel;           //订单原价
@property (nonatomic, strong) UILabel *realPriceLabel;               //订单实际价格
@property (nonatomic, strong) UIButton *checkOrderBtn;            //查看订单按钮
@property (nonatomic, strong) UIButton *payOrderBtn;               //支付订单按钮

@end

@implementation ScanResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"优惠订单"];
    
    [self.view addSubview:self.logoImgView];
    [self.view addSubview:self.storeNameLabel];
    [self.view addSubview:self.originalPriceLabel];
    [self.view addSubview:self.realPriceLabel];
    [self.view addSubview:self.checkOrderBtn];
    [self.view addSubview:self.payOrderBtn];
}

#pragma mark - Get Method
- (UIImageView *)logoImgView
{
    if (!_logoImgView) {
        _logoImgView = ({
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
//            [imageView setImage:[UIImage imageNamed:@"product_placeholder"]];
            [imageView setImageWithURL:[NSURL URLWithString:self.orderInfoDic[@"logo"]] placeholderImage:[UIImage imageNamed:@"product_placeholder"]];
            imageView;
        });
    }
    return _logoImgView;
}

- (UILabel *)storeNameLabel
{
    if (!_storeNameLabel) {
        _storeNameLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, kScreenWidth-100, 60)];
            [label setText:self.orderInfoDic[@"businessname"]];
            [label setTextColor:UIColorFromHex(0x3c3c3c, 1)];
            [label setFont:UIFontPingFangMedium(16.0f)];
            [label setNumberOfLines:0];
            [label setLineBreakMode:NSLineBreakByCharWrapping];
            
            label;
        });
    }
    return _storeNameLabel;
}

- (UILabel *)originalPriceLabel
{
    if (!_originalPriceLabel) {
        _originalPriceLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, kScreenWidth, 30)];
            [label setText:@"原价：￥22元"];
            [label setText:[NSString stringWithFormat:@"原价：￥%.2f",[self.orderInfoDic[@"price"] floatValue]]];
            [label setTextColor:UIColorFromHex(0x696969, 1)];
            [label setFont:UIFontPingFangMedium(20.0f)];
            [label setTextAlignment:NSTextAlignmentCenter];

            //中划线
            NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
            NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:label.text attributes:attribtDic];
            label.attributedText = attribtStr;

            label;
        });
    }
    return _originalPriceLabel;
}

- (UILabel *)realPriceLabel
{
    if (!_realPriceLabel) {
        _realPriceLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 230, kScreenWidth, 30)];
            [label setText:@"￥12.00"];
            [label setText:[NSString stringWithFormat:@"￥%.2f",[self.orderInfoDic[@"payprice"] floatValue]]];
            [label setTextColor:kMainColor];
            [label setFont:UIFontPingFangMedium(22.0f)];
            [label setTextAlignment:NSTextAlignmentCenter];
            
            label;
        });
    }
    return _realPriceLabel;
}

- (UIButton *)checkOrderBtn
{
    if (!_checkOrderBtn) {
        _checkOrderBtn = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake((kScreenWidth/2-130)/2, kScreenHeight-kNavigationBarHight-70, 130, 35)];
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 5.0f;
            button.layer.borderColor = [kMainColor CGColor];
            button.layer.borderWidth = 1.0f;
            [button setTitle:@"查看订单" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(0xffa08e, 1) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(clickCheckOrderBtn:) forControlEvents:UIControlEventTouchUpInside];
        
            button;
        });
    }
    return _checkOrderBtn;
}

- (UIButton *)payOrderBtn
{
    if (!_payOrderBtn) {
        _payOrderBtn = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake((kScreenWidth/2-130)/2+kScreenWidth/2, kScreenHeight-kNavigationBarHight-70, 130, 35)];
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 5.0f;
            button.layer.borderColor = [kMainColor CGColor];
            button.layer.borderWidth = 1.0f;
            [button setTitle:@"支付" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageWithColor:kMainColor size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(clickPayOrderBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            button;
        });
    }
    return _payOrderBtn;
}

#pragma mark - UIButton Action
- (void)clickCheckOrderBtn:(UIButton *)sender
{
    NSLog(@"查看订单");
    OrderDetailViewController *orderDetailVC = [[OrderDetailViewController alloc] init];
    orderDetailVC.orderInfoDict = self.orderInfoDic;
    orderDetailVC.isOffLine = YES;
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}

- (void)clickPayOrderBtn:(UIButton *)sender
{
    NSLog(@"支付订单");
    
    FavorableOrderPayViewController *vc = [FavorableOrderPayViewController new];
    vc.orderID = [NSString stringWithFormat:@"%@",self.orderInfoDic[@"orderid"]];
    vc.orderDic = self.orderInfoDic;
    vc.orderPrice = [NSString stringWithFormat:@"%.2f",[self.orderInfoDic[@"payprice"] floatValue]];
    [self.navigationController pushViewController:vc animated:YES];
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
