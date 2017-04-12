//
//  OrderListViewController.m
//  ShareBuyUser
//
//  Created by Marx on 16/8/9.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "OrderListViewController.h"

#import "OrderTableViewHeaderView.h"
#import "OrderTableViewFooterView.h"
#import "OrderTableViewGoodCell.h"

#import "OrderDetailViewController.h"

#import "OrderPayViewController.h"
#import "OrderCommentViewController.h"
#import "OrderRefundViewController.h"

@interface OrderListViewController ()<UITableViewDelegate,UITableViewDataSource,OrderTableViewFooterViewDelegate>

@property(nonatomic)UIButton *selectedFilterButton;

@property(nonatomic)NSInteger page;
@property(nonatomic)UITableView *orderTableView;
@property(nonatomic,copy)NSMutableArray *orderArray;

@end

@implementation OrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"我的订单"];
    _page = 1;
    [self customView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_orderTableView.legendHeader beginRefreshing];
    
}

#pragma mark Request Data
- (void)requestOrderList
{
    NSString *status = @"";
    if (_selectedFilterButton.tag == 99) {
        status = @"-1";
    }else if(_selectedFilterButton.tag == 104)
    {
        status = @"4";
    }else{
        status = [NSString stringWithFormat:@"%ld",_selectedFilterButton.tag -100];
    }
    
    NSDictionary *dict = @{@"token":[UserModel shareUserModel].userToken,@"state":status,@"pageIndex":[NSString stringWithFormat:@"%ld",(long)_page]};
    NSLog(@"%@",dict);
    
    [DDPBLL requestWithURL:DEF_URL_GetOrderList  Dict:dict result:^(NSDictionary *responseDict) {
        [self hideHud];
        NSLog(@"%@",responseDict);
        [_orderTableView.legendHeader endRefreshing];
        [_orderTableView.legendFooter endRefreshing];
        if (responseDict == nil) {
//            [self showHint:@"处理失败，请稍后再试"];
            return ;
        }
        if ([[responseDict objectForKey:@"status"] integerValue]==0) {
            
            if (_page == 1) {
                
                _page++;
                _orderArray = [[NSMutableArray alloc] initWithArray:responseDict[@"data"]];
                [_orderTableView reloadData];
            }else{
                _page++;
                [_orderArray addObjectsFromArray:responseDict[@"data"]];
                [_orderTableView reloadData];
            }
            
            
        }else{
            [self showHint:responseDict[@"msg"]];
        }
    }];
}

- (void)requestCancelOrderDataWithOID:(NSString *)oID
{
    NSDictionary *dict = @{@"token":[UserModel shareUserModel].userToken,@"oid":oID};
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
            [_orderTableView.legendHeader beginRefreshing];
        }else{
            [self showHint:responseDict[@"msg"]];
        }
    }];
}

//确认收货接口
- (void)requestTakeOrderDataWithOID:(NSString *)oID
{
    NSDictionary *dict = @{@"token":[UserModel shareUserModel].userToken,@"oid":oID};
    NSLog(@"%@",dict);
    
    [self showHudInView:self.view hint:nil];
    [DDPBLL requestWithURL:DEF_URL_TakeOrder  Dict:dict result:^(NSDictionary *responseDict) {
        [self hideHud];
        NSLog(@"%@",responseDict);
        if (responseDict == nil) {
            //            [self showHint:@"处理失败，请稍后再试"];
            return ;
        }
        if ([[responseDict objectForKey:@"status"] integerValue]==0) {
            [_orderTableView.legendHeader beginRefreshing];
        }else{
            [self showHint:responseDict[@"msg"]];
        }
    }];
}

#pragma mark Custom View
- (void)customView
{
    UIView *filterView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        [view setBackgroundColor:[UIColor whiteColor]];
        
        NSArray *titleArray = @[@"全部",@"待付款",@"待发货",@"待收货",@"待评价",@"售后/退款"];
        for (int i = 0; i<6; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            [button setFrame:CGRectMake(kScreenWidth/6*i, 0, kScreenWidth/6, 40)];
            [button setTitle:titleArray[i] forState:UIControlStateNormal];
            [button setTitleColor:UIColorFromHex(0x999999, 1) forState:UIControlStateNormal];
            [button setTitleColor:kMainColor forState:UIControlStateSelected];
            [button.titleLabel setFont:UIFontPingFangRegular(13)];
            
            [button setTag:99+i];
            if (i  == 0) {
                _selectedFilterButton = button;
                [_selectedFilterButton setSelected:YES];
            }else{
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth/6-0.25)*i, 10, 0.5, 20)];
                [lineView setBackgroundColor:UIColorFromHex(0xbbbbbb, 1)];
                [view addSubview:lineView];
            }
            
            [button addTarget:self action:@selector(selectFilterButton:) forControlEvents:UIControlEventTouchUpInside];
            
            [view addSubview:button];
        }
        
        view;
    });
    
    [self.view addSubview:filterView];
    [self.view addSubview:self.orderTableView];
}

- (UITableView *)orderTableView
{
    if (!_orderTableView) {
        _orderTableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth , kScreenHeight - kNavigationBarHight - 40) style:UITableViewStyleGrouped];
            [tableView setDelegate:self];
            [tableView setDataSource:self];
            [tableView setBackgroundColor:[UIColor clearColor]];
//            [tableView setSeparatorColor:UIColorFromHex(0xbbbbbb, 1)];
            [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            
            tableView.tableFooterView = [UIView new];
            
            [tableView addLegendHeaderWithRefreshingBlock:^{
                _page = 1;
                [self requestOrderList];
            }];
            
            [tableView addLegendFooterWithRefreshingBlock:^{
                [self requestOrderList];
            }];
            
            tableView;
        });
    }
    return _orderTableView;
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_orderArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *headerID = @"OrderHeader";
    OrderTableViewHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
    if (!headerView) {
        headerView = [[OrderTableViewHeaderView alloc] initWithReuseIdentifier:headerID];
        [headerView setFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    }
    if ([_orderArray[section][@"businessname"] length] == 0) {
        [headerView.merchantNameLabel setText:@"分享购自营"];
    }else
    {
        [headerView.merchantNameLabel setText:_orderArray[section][@"businessname"]];
    }
    NSString *stateString = @"";
    //-1取消0未付款1待发货2待收货3待评价4已完成5申请退款6退款完成
    switch ([_orderArray[section][@"state"] integerValue]) {
        case -1:
            stateString = @"已取消";
            break;
        case 0:
            stateString = @"未付款";
            break;
        case 1:
            stateString = @"待发货";
            break;
        case 2:
            stateString = @"待收货";
            break;
        case 3:
            stateString = @"待评价";
            break;
        case 4:
            stateString = @"已完成";
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
    [headerView.statusLabel setText:stateString];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 70;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    static NSString *footerID = @"OrderFooter";
    OrderTableViewFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerID];
    if (!footerView) {
        footerView = [[OrderTableViewFooterView alloc] initWithReuseIdentifier:footerID];
        [footerView setFrame:CGRectMake(0, 0, kScreenWidth, 70)];
    }
    NSInteger num = [_orderArray[section][@"goodsList"] count];
    CGFloat price = [_orderArray[section][@"price"] floatValue];
    CGFloat freight = [_orderArray[section][@"freight"] floatValue];
    [footerView.orderInfoLabel setText:[NSString stringWithFormat:@"共%ld件商品 合计:¥%.2f (含运费¥%.2f)",(long)num,price,freight]];
    [footerView.payButton setHidden:YES];
    [footerView.cancelButton setHidden:YES];
    [footerView.confirmButton setHidden:YES];
    [footerView.commentButton setHidden:YES];
    [footerView.refundButton setHidden:YES];
    switch ([_orderArray[section][@"state"] integerValue]) {
        case 0:
            //未付款
            [footerView.payButton setHidden:NO];
            [footerView.cancelButton setHidden:NO];
            break;
        case 2:
            //待收货
            [footerView.confirmButton setHidden:NO];
            break;
        case 3:
            //未评价
            [footerView.commentButton setHidden:NO];
            [footerView.refundButton setHidden:NO];
            break;
        case 4:
            //已完成
            [footerView.refundButton setHidden:NO];
            break;
            
        default:
            break;
    }
    footerView.section = section;
    [footerView setDelegate:self];
    
    return footerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_orderArray[section][@"goodsList"] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"GoodCell";
    OrderTableViewGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[OrderTableViewGoodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setDic:_orderArray[indexPath.section][@"goodsList"][indexPath.row]];
    if (indexPath.row == [_orderArray[indexPath.section][@"goodsList"] count]-1) {
        [cell.lineView setHidden:YES];
    }else{
        [cell.lineView setHidden:NO];
    }
    
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderDetailViewController *vc = [OrderDetailViewController new];
    if ([_orderArray[indexPath.section][@"paykind"] integerValue] == 1) {
        vc.isOffLine = NO;
    }else{
        vc.isOffLine = YES;
    }
    vc.orderID = _orderArray[indexPath.section][@"oid"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark OrderTableViewFooterViewDelegate
//支付
- (void)selectFooterViewPayButtonWithSection:(NSInteger)section
{
    OrderPayViewController *vc = [OrderPayViewController new];
    vc.orderType = @"0";
    vc.shareID = [NSString stringWithFormat:@"%@",_orderArray[section][@"shareid"]];
    vc.orderDic = _orderArray[section];
    [self.navigationController pushViewController:vc animated:YES];
}

//评价
- (void)selectFooterViewCommentButtonWithSection:(NSInteger)section
{
    OrderCommentViewController *vc = [OrderCommentViewController new];
    vc.isGoodsList = YES;
    vc.orderDic = _orderArray[section];
    [self.navigationController pushViewController:vc animated:YES];
}

//退货
- (void)selectFooterViewRefundButtonWithSection:(NSInteger)section
{
    OrderRefundViewController *vc = [OrderRefundViewController new];
    vc.orderDic = _orderArray[section];
    [self.navigationController pushViewController:vc animated:YES];
}

//取消订单
- (void)selectFooterViewCancelButtonWithSection:(NSInteger)section
{
    [self requestCancelOrderDataWithOID:_orderArray[section][@"oid"]];
}

//确认收货
- (void)selectFooterViewConfirmButtonWithSection:(NSInteger)section
{
    [self requestTakeOrderDataWithOID:_orderArray[section][@"oid"]];
}

#pragma mark Button Action
- (IBAction)selectFilterButton:(UIButton *)sender
{
    if (_selectedFilterButton.tag !=sender.tag) {
        [_selectedFilterButton setSelected:NO];
        _selectedFilterButton = sender;
        [_selectedFilterButton setSelected:YES];
        [_orderTableView.legendHeader beginRefreshing];
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
