//
//  OrderDetailViewController.m
//  ShareBuyUser
//
//  Created by Marx on 16/8/10.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "OrderDetailViewController.h"

#import "OrderDetailTableViewInfoCell.h"
#import "OrderDetailTableViewReceiveHeaderView.h"
#import "OrderDetailTableViewReceiveInfoCell.h"
#import "OrderDetailTableViewMerchantHeaderView.h"
#import "OrderDetailTableViewMerchantFooterView.h"

#import "OrderTableViewGoodCell.h"

#import "OrderPayViewController.h"
#import "OrderCommentViewController.h"
#import "OrderRefundViewController.h"

@interface OrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic)UIBarButtonItem *cancelBarButtonItem;
@property(nonatomic)UIBarButtonItem *refundBarButtonItem;

@property(nonatomic)UITableView *orderDetailTableView;
//@property (nonatomic, strong) UIView *bottomView;
@property(nonatomic)UIView *controlView;
@property(nonatomic)UILabel *totalPriceLabel;
@property(nonatomic)UIButton *payButton;
@property(nonatomic)UIButton *confirmButton;
@property(nonatomic)UIButton *commentButton;

@property(nonatomic)NSArray *infoTitleArray;
@property (nonatomic, strong) NSMutableArray *infoValueArray;

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"订单详情"];
    [self initData];
    [self customView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_isOffLine) {
        if (_orderInfoDict) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self.orderInfoDict[@"ctime"] longLongValue]/1000];
            NSString *timeStr = [dateFormatter stringFromDate:date];
            _infoValueArray = [NSMutableArray arrayWithArray:@[self.orderInfoDict[@"orderid"],timeStr]];
            
            NSMutableAttributedString *priceString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"合计：￥%.2f",[self.orderInfoDict[@"payprice"] floatValue]]];
            [priceString addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0x696969, 1) range:NSMakeRange(0,3)];
            
            [_totalPriceLabel setAttributedText:priceString];
            //-1取消0未付款1待发货2待收货3待评价4已完成5申请退款6退款完成
            [_payButton setHidden:YES];
            [_confirmButton setHidden:YES];
            [_commentButton setHidden:YES];
            switch ([_orderInfoDict[@"state"] integerValue]) {
                case 0:
//                    stateString = @"未付款";
                    [_payButton setHidden:NO];
                    break;
                case 2:
//                    stateString = @"待收货";
                    [_confirmButton setHidden:NO];
                    break;
                case 3:
//                    stateString = @"待评价";
                    [_commentButton setHidden:NO];
                    break;
                default:
                    break;
            }
        }else{
            [self requestOrderData];
        }
    }else{
        [self requestOrderData];
    }
    
}

#pragma mark Request Data
- (void)requestOrderData
{
    NSDictionary *dict = @{@"token":[UserModel shareUserModel].userToken,@"oid":_orderID};
    NSLog(@"%@",dict);
    
    [self showHudInView:self.view hint:nil];
    [DDPBLL requestWithURL:DEF_URL_GetOrderDetail  Dict:dict result:^(NSDictionary *responseDict) {
        [self hideHud];
        NSLog(@"%@",responseDict);
        if (responseDict == nil) {
            //            [self showHint:@"处理失败，请稍后再试"];
            return ;
        }
        if ([[responseDict objectForKey:@"status"] integerValue]==0) {
            _orderInfoDict = responseDict[@"data"];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self.orderInfoDict[@"ctime"] longLongValue]/1000];
            NSString *timeStr = [dateFormatter stringFromDate:date];
            NSString *stateString = @"";
            //-1取消0未付款1待发货2待收货3待评价4已完成5申请退款6退款完成
            [_payButton setHidden:YES];
            [_confirmButton setHidden:YES];
            [_commentButton setHidden:YES];
            self.navigationItem.rightBarButtonItem = nil;
            switch ([_orderInfoDict[@"state"] integerValue]) {
                case -1:
                    stateString = @"已取消";
                    break;
                case 0:
                    stateString = @"未付款";
                    self.navigationItem.rightBarButtonItem = self.cancelBarButtonItem;
                    [_payButton setHidden:NO];
                    break;
                case 1:
                    stateString = @"待发货";
                    break;
                case 2:
                    stateString = @"待收货";
                    [_confirmButton setHidden:NO];
                    break;
                case 3:
                    stateString = @"待评价";
                    self.navigationItem.rightBarButtonItem = self.refundBarButtonItem;
                    [_commentButton setHidden:NO];
                    break;
                case 4:
                    stateString = @"已完成";
                    self.navigationItem.rightBarButtonItem = self.refundBarButtonItem;
                    break;
                case 5:
                    stateString = @"申请退款";
                    break;
                case 6:
                    stateString = @"退款完成";
                    break;
                    
                default:
                    break;
            }
            NSMutableAttributedString *priceString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"合计：￥%.2f",[self.orderInfoDict[@"price"] floatValue]]];
            [priceString addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0x696969, 1) range:NSMakeRange(0,3)];
            [_totalPriceLabel setAttributedText:priceString];
            
            _infoValueArray = [NSMutableArray arrayWithArray:@[self.orderInfoDict[@"orderid"],timeStr,stateString]];
            [_orderDetailTableView reloadData];
            
            
        }else{
            [self showHint:responseDict[@"msg"]];
        }
    }];
}

- (void)requestCancelOrderData
{
    NSDictionary *dict = @{@"token":[UserModel shareUserModel].userToken,@"oid":_orderID};
    NSLog(@"%@",dict);
    
    [self showHudInView:self.view hint:nil];
    [DDPBLL requestWithURL:DEF_URL_CancelOrder  Dict:dict result:^(NSDictionary *responseDict) {
        [self hideHud];
        NSLog(@"%@",responseDict);
        if (responseDict == nil) {
            //            [self showHint:@"处理失败，请稍后再试"];
            return ;
        }
        if ([[responseDict objectForKey:@"status"] integerValue]==0) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showHint:responseDict[@"msg"]];
        }
    }];
}

#pragma mark Init Data
- (void)initData
{
    _infoTitleArray = @[@"订单号:",@"下单时间:",@"订单状态:"];
}

#pragma mark Custom View
- (void)customView
{
    [self.view addSubview:self.orderDetailTableView];
    [self.view addSubview:self.controlView];
}

- (UIBarButtonItem *)cancelBarButtonItem
{
    if (!_cancelBarButtonItem) {
        _cancelBarButtonItem = ({
            UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消订单" style:UIBarButtonItemStylePlain target:self action:@selector(selectCancelButton:)];
            
            barButtonItem;
        });
    }
    return _cancelBarButtonItem;
}

- (UIBarButtonItem *)refundBarButtonItem
{
    if (!_refundBarButtonItem) {
        _refundBarButtonItem = ({
            UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"售后/退款" style:UIBarButtonItemStylePlain target:self action:@selector(selectRefundButton:)];
            barButtonItem;
        });
    }
    return _refundBarButtonItem;
}

- (UITableView *)orderDetailTableView
{
    if (!_orderDetailTableView) {
        _orderDetailTableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHight-45) style:UITableViewStylePlain];
            [tableView setDelegate:self];
            [tableView setDataSource:self];
            [tableView setBackgroundColor:[UIColor clearColor]];
            [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            
            tableView.tableFooterView = [UIView new];
            
            tableView;
        });
    }
    return _orderDetailTableView;
}


- (UIView *)controlView
{
    if (!_controlView) {
        _controlView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,  kScreenHeight-45-kNavigationBarHight, kScreenWidth, 45)];
            [view setBackgroundColor:[UIColor whiteColor]];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
            [lineView setBackgroundColor:UIColorFromHex(0xbbbbbb, 1)];
            [view addSubview:lineView];
            
            [view addSubview:self.totalPriceLabel];
            
            [view addSubview:self.payButton];
            [view addSubview:self.confirmButton];
            [view addSubview:self.commentButton];
            
            view;
        });
    }
    
    return _controlView;
}

- (UILabel *)totalPriceLabel
{
    if (!_totalPriceLabel) {
        _totalPriceLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-140, 45)];
            [label setFont:UIFontPingFangRegular(15)];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setTextColor:kMainColor];
            label;
        });
    }
    return _totalPriceLabel;
}

- (UIButton *)payButton
{
    if (!_payButton) {
        _payButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(kScreenWidth -140, 0, 140, 45)];
            [button setBackgroundImage:[UIImage imageWithColor:kMainColor size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
            [button setTitle:@"去付款" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button.titleLabel setFont:UIFontPingFangRegular(15)];
            
            [button addTarget:self action:@selector(selectPayButton:) forControlEvents:UIControlEventTouchUpInside];
            
            button;
        });
    }
    return _payButton;
}

- (UIButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(kScreenWidth -140, 0, 140, 45)];
            [button setBackgroundImage:[UIImage imageWithColor:kMainColor size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
            [button setTitle:@"确认收货" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button.titleLabel setFont:UIFontPingFangRegular(15)];
            
            [button addTarget:self action:@selector(selectConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
            
            button;
        });
    }
    return _confirmButton;
}

- (UIButton *)commentButton
{
    if (!_commentButton) {
        _commentButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(kScreenWidth -140, 0, 140, 45)];
            [button setBackgroundImage:[UIImage imageWithColor:kMainColor size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
            [button setTitle:@"评价" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button.titleLabel setFont:UIFontPingFangRegular(15)];
            
            [button addTarget:self action:@selector(selectCommentButton:) forControlEvents:UIControlEventTouchUpInside];
            
            button;
        });
    }
    return _commentButton;
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_isOffLine) {
        return 2;
    }else{
        return 3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 0;
            break;
        case 1:
            if (_isOffLine) {
                return 40;
            }else{
                return 30;
            }
            break;
        case 2:
            return 40;
            break;
            
        default:
            return 0;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return nil;
            break;
        case 1:
        {
            if (_isOffLine) {
                static NSString *headerID = @"MerchantHeader";
                OrderDetailTableViewMerchantHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
                if (!headerView) {
                    headerView = [[OrderDetailTableViewMerchantHeaderView alloc] initWithReuseIdentifier:headerID];
                    [headerView setFrame:CGRectMake(0, 0, kScreenWidth, 40)];
                }
                
//                [headerView.merchantNameLabel setText:@"商户名称"];
                if ([self.orderInfoDict[@"businessname"] length] == 0) {
                    [headerView.merchantNameLabel setText:@"分享购自营"];
                }else
                {
                    [headerView.merchantNameLabel setText:self.orderInfoDict[@"businessname"]];
                }
                
                return headerView;
            }else{
                static NSString *headerID = @"ReceiveHeader";
                OrderDetailTableViewReceiveHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
                if (!headerView) {
                    headerView = [[OrderDetailTableViewReceiveHeaderView alloc] initWithReuseIdentifier:headerID];
                    [headerView setFrame:CGRectMake(0, 0, kScreenWidth, 30)];
                }
                
                return headerView;
            }
        }
            break;
        case 2:
        {
            static NSString *headerID = @"MerchantHeader";
            OrderDetailTableViewMerchantHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
            if (!headerView) {
                headerView = [[OrderDetailTableViewMerchantHeaderView alloc] initWithReuseIdentifier:headerID];
                [headerView setFrame:CGRectMake(0, 0, kScreenWidth, 40)];
            }
            
            if ([self.orderInfoDict[@"businessname"] length] == 0) {
                [headerView.merchantNameLabel setText:@"分享购自营"];
            }else
            {
                [headerView.merchantNameLabel setText:self.orderInfoDict[@"businessname"]];
            }
            
            return headerView;
        }
            break;
        default:
            return nil;
            break;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 0;
            break;
        case 1:
            return 0;
            break;
        case 2:
            if (_isOffLine) {
                return 0;
            }else{
                return 20;
            }
            break;
            
        default:
            return 0;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return nil;
            break;
        case 1:
            return nil;
            break;
        case 2:
        {
            if (_isOffLine) {
                return nil;
            }else{
                static NSString *footerID = @"MerchantFooter";
                OrderDetailTableViewMerchantFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerID];
                if (!footerView) {
                    footerView = [[OrderDetailTableViewMerchantFooterView alloc] initWithReuseIdentifier:footerID];
                    [footerView setFrame:CGRectMake(0, 0, kScreenWidth, 20)];
                }
                
                [footerView.expressNameLabel setText:_orderInfoDict[@"express"]];
                
                return footerView;
            }
        }
            break;
            
        default:
            return nil;
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            if (_isOffLine) {
                return 2;
            }else{
                return 3;
            }
            break;
        case 1:
            if (_isOffLine) {
                return [self.orderInfoDict[@"listTO"] count];
            }else{
                return 1;
            }
            break;
        case 2:
            return [self.orderInfoDict[@"listTO"] count];
            break;
            
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 45;
            break;
        case 1:
            if (_isOffLine) {
                return 90;
            }else{
                return 90;
            }
            break;
        case 2:
            return 90;
            break;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            static NSString *cellID = @"InfoCell";
            OrderDetailTableViewInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell = [[OrderDetailTableViewInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            [cell.titleLabel setText:_infoTitleArray[indexPath.row]];
            [cell.valueLabel setText:[NSString stringWithFormat:@"%@",_infoValueArray[indexPath.row]]];
            if (_isOffLine) {
                if (indexPath.row == 1) {
                    [cell.lineView setHidden:YES];
                }else{
                    [cell.lineView setHidden:NO];
                }
            }else{
                if (indexPath.row == 2) {
                    [cell.lineView setHidden:YES];
                }else{
                    [cell.lineView setHidden:NO];
                }
            }
            
            if (indexPath.row == 2) {
                [cell.valueLabel setTextColor:kMainColor];
            }else{
                [cell.valueLabel setTextColor:UIColorFromHex(0x999999, 1)];
            }
            
            return cell;
        }
            break;
        case 1:
        {
            if (_isOffLine) {
                static NSString *cellID = @"GoodCell";
                OrderTableViewGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
                if (!cell) {
                    cell = [[OrderTableViewGoodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                [cell.goodImageView setImageWithURL:[NSURL URLWithString:self.orderInfoDict[@"listTO"][indexPath.row][@"imgurl"]] placeholderImage:[UIImage imageNamed:@"product_placeholder"]];
                [cell.goodNameLabel setText:self.orderInfoDict[@"listTO"][indexPath.row][@"goodsname"]];
                [cell.goodPriceLabel setText:[NSString stringWithFormat:@"￥%@",self.orderInfoDict[@"listTO"][indexPath.row][@"offprice"]]];
                [cell.goodNumLabel setText:[NSString stringWithFormat:@"%@",self.orderInfoDict[@"listTO"][indexPath.row][@"num"]]];
                if (indexPath.row == 1) {
                    [cell.lineView setHidden:YES];
                }else{
                    [cell.lineView setHidden:NO];
                }
                
                return cell;
            }else{
                static NSString *cellID = @"ReceiveCell";
                OrderDetailTableViewReceiveInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
                if (!cell) {
                    cell = [[OrderDetailTableViewReceiveInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                NSMutableDictionary *mDic = [[NSMutableDictionary alloc] initWithDictionary:_orderInfoDict[@"orderAddressDetailTO"]];
                for (int i = 0; i<[[mDic allKeys] count]; i++) {
                    if ([[mDic allValues][i] isKindOfClass:[NSNull class]]) {
                        [mDic setValue:@"" forKey:[mDic allKeys][i]];
                    }
                }
                NSMutableAttributedString *nameString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"收件人：%@",mDic[@"name"]]];
                [nameString addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0x696969, 1) range:NSMakeRange(0, 4)];
                [cell.nameLabel setAttributedText:nameString];
                NSMutableAttributedString *phoneString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"联系电话：%@",mDic[@"phone"]]];
                [phoneString addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0x696969, 1) range:NSMakeRange(0, 5)];
                
                [cell.phoneLabel setAttributedText:phoneString];
                
                [cell.addressLabel setText:mDic[@"address"]];
                
                return cell;
            }
        }
            break;
        case 2:
        {
            static NSString *cellID = @"GoodCell";
            OrderTableViewGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell = [[OrderTableViewGoodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            [cell.goodImageView setImageWithURL:[NSURL URLWithString:self.orderInfoDict[@"listTO"][indexPath.row][@"imgurl"]] placeholderImage:[UIImage imageNamed:@"product_placeholder"]];
            [cell.goodNameLabel setText:self.orderInfoDict[@"listTO"][indexPath.row][@"goodsname"]];
            [cell.goodPriceLabel setText:[NSString stringWithFormat:@"￥%.2f",[self.orderInfoDict[@"listTO"][indexPath.row][@"onprice"] floatValue]]];
            [cell.goodNumLabel setText:[NSString stringWithFormat:@"x%@",self.orderInfoDict[@"listTO"][indexPath.row][@"num"]]];

            if (indexPath.row == 1) {
                [cell.lineView setHidden:YES];
            }else{
                [cell.lineView setHidden:NO];
            }
            
            return cell;
        }
            break;
            
        default:
            return nil;
            break;
    }
}

#pragma mark Button Action
- (IBAction)selectPayButton:(id)sender
{
    OrderPayViewController *vc = [OrderPayViewController new];
    vc.orderDic = _orderInfoDict;
    vc.orderType = @"0";
    if (_isOffLine) {
        vc.shareID = @"扫码支付";
    }else
    {
        if ([_orderInfoDict[@"shareid"] length] == 0) {
            vc.shareID = @"";
        }else
        {
            vc.shareID = [NSString stringWithFormat:@"%@",_orderInfoDict[@"shareid"]];
        }
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)selectCommentButton:(id)sender
{
    OrderCommentViewController *vc = [OrderCommentViewController new];
    vc.isGoodsList = NO;
    vc.orderDic = _orderInfoDict;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)selectRefundButton:(id)sender
{
    OrderRefundViewController *vc = [OrderRefundViewController new];
    vc.orderDic = _orderInfoDict;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)selectCancelButton:(id)sender
{
    [self requestCancelOrderData];
}

//确认收货
- (IBAction)selectConfirmButton:(id)sender
{
    NSDictionary *dic = @{@"token":[UserModel shareUserModel].userToken,@"oid":_orderID};
    [self takeOrderInfoRequestWithDict:dic];
}

#pragma mark - Networking  
- (void)takeOrderInfoRequestWithDict:(NSDictionary *)dict
{
    [self showHudInView:self.view hint:nil];
    [DDPBLL requestWithURL:DEF_URL_TakeOrder  Dict:dict result:^(NSDictionary *responseDict) {
        [self hideHud];
        NSLog(@"%@",responseDict);
        if (responseDict == nil) {
            [self showHint:@"处理失败，请稍后再试"];
            return ;
        }
        if ([[responseDict objectForKey:@"status"] integerValue]==0) {
            NSLog(@"确认收货");
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
