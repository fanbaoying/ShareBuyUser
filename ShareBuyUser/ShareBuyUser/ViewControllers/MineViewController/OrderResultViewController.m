//
//  OrderResultViewController.m
//  ShareBuyUser
//
//  Created by soldier on 16/8/29.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "OrderResultViewController.h"
#import "AddShareViewController.h"

@interface OrderResultViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *oResultTableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIBarButtonItem *backBarBtnItem;
@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation OrderResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"支付结果";
    
    self.titleArray = @[@"订单号：",@"应付金额：",@"支付方式："];
    if ([_orderid length] == 0)
    {
        self.dataArray = [NSMutableArray arrayWithArray:@[_orderDict[@"orderid"],[NSString stringWithFormat:@"￥%.2f",[_orderDict[@"price"] floatValue]],_paymentStr]];
    }else
    {
        self.dataArray = [NSMutableArray arrayWithArray:@[_orderid,_orderPrice,_paymentStr]];
    }

    self.navigationItem.leftBarButtonItem = self.backBarBtnItem;
    [self.view addSubview:self.oResultTableView];
    [self.view addSubview:self.confirmButton];
    
}

#pragma mark - Get Method
- (UITableView *)oResultTableView
{
    if (!_oResultTableView) {
        _oResultTableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHight) style:UITableViewStylePlain];
            [tableView setBackgroundColor:[UIColor clearColor]];
            [tableView setDelegate:self];
            [tableView setDataSource:self];
            [tableView setTableHeaderView:self.headerView];
            [tableView setTableFooterView:[UIView new]];
            
            
            tableView;
        });
    }
    return _oResultTableView;
}

- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 140)];
            [view setBackgroundColor:[UIColor whiteColor]];
            
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-70)/2, 20, 70, 70)];
            [imgView setImage:[UIImage imageNamed:@"orderpay_success"]];
            [view addSubview:imgView];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, 30)];
            [label setFont:UIFontPingFangMedium(16.0f)];
            [label setText:@"购买成功"];
            [label setTextAlignment:NSTextAlignmentCenter];
            [view addSubview:label];
            
            view;
        });
    }
    return _headerView;
}

- (UIBarButtonItem *)backBarBtnItem
{
    if (!_backBarBtnItem) {
        _backBarBtnItem = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(0, 0, 20, 30)];
            [button setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(clickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:button];
            
            barBtnItem;
        });
    }
    return _backBarBtnItem;
}

- (UIButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(15, kScreenHeight-kNavigationBarHight-65, kScreenWidth-30, 35)];
            [button.layer setMasksToBounds:YES];
            button.layer.cornerRadius = 3.0f;
            [button setBackgroundImage:[UIImage imageWithColor:kMainColor size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
            [button setTitle:@"确定" forState:UIControlStateNormal];
            [button.titleLabel setFont:UIFontPingFangRegular(18.0f)];
            [button addTarget:self action:@selector(clickConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            button;
        });
    }
    return _confirmButton;
}

- (UIBarButtonItem *)shareBarBtnItem
{
    if (!_shareBarBtnItem) {
        _shareBarBtnItem = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(0, 0, 40, 20)];
            [button setTitle:@"分享" forState:UIControlStateNormal];
            button.titleLabel.font = UIFontPingFangRegular(14.0f);
            [button addTarget:self action:@selector(clickShareBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:button];
            
            barBtnItem;
        });
    }
    return _shareBarBtnItem;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"选择cell");
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_titleArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setBackgroundColor:[UIColor whiteColor]];
        //        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsZero];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 45)];
    [titleLabel setFont:UIFontPingFangMedium(14.0f)];
    [titleLabel setText:_titleArray[indexPath.row]];
    [cell addSubview:titleLabel];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-210, 0, 200, 45)];
    [contentLabel setFont:UIFontPingFangMedium(14.0f)];
    [contentLabel setTextAlignment:NSTextAlignmentRight];
    contentLabel.adjustsFontSizeToFitWidth = YES;
    [contentLabel setText:[NSString stringWithFormat:@"%@",_dataArray[indexPath.row]]];
    [contentLabel setTextColor:UIColorFromHex(0x696969, 1)];
    [cell addSubview:contentLabel];
    
    switch (indexPath.row) {
        case 1:
            [contentLabel setTextColor:kMainColor];
            break;
            
        default:
            break;
    }
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44.5, kScreenWidth, 0.5f)];
    [lineView setBackgroundColor:UIColorFromHex(0xcccccc, 1)];
    [cell addSubview:lineView];
    
    return cell;
}

#pragma mark - UIButton Action
- (void)clickBackBtn:(UIButton *)button
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)clickShareBtn:(UIButton *)button
{
    NSLog(@"分享订单");
    AddShareViewController *addShareVC = [[AddShareViewController alloc] init];
    if ([_orderType integerValue] == 0) {
        addShareVC.orderID = _orderDict[@"oid"];
    }else
    {
        addShareVC.orderID = _orderDict[@"orderid"];
    }
    addShareVC.orderType = _orderType;
    [self.navigationController pushViewController:addShareVC animated:YES];
}

- (void)clickConfirmBtn:(UIButton *)button
{
    NSLog(@"确认订单支付成功");
    [self.navigationController popToRootViewControllerAnimated:YES];
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
