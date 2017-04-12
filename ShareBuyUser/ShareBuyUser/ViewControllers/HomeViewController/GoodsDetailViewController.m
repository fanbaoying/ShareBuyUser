//
//  GoodsDetailViewController.m
//  ShareBuyUser
//
//  Created by soldier on 16/8/10.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "GoodsDetailViewController.h"

@interface GoodsDetailViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *goodsTableView;
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) UIView *tableFooterView;

@end

@implementation GoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (UITableView *)goodsTableView
{
    if (_goodsTableView) {
        _goodsTableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
            [tableView setDelegate:self];
            [tableView setDataSource:self];
            [tableView setBackgroundColor:[UIColor clearColor]];
            [tableView setTableHeaderView:self.tableHeaderView];
            [tableView setTableFooterView:self.tableFooterView];
            [tableView setSeparatorInset:UIEdgeInsetsZero];
            [tableView setLayoutMargins:UIEdgeInsetsZero];
            [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            
            tableView;
        });
    }
    return _goodsTableView;
}

- (UIView *)tableHeaderView
{
    if (!_tableHeaderView) {
        _tableHeaderView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
            view;
        });
    }
    return _tableHeaderView;
}

- (UIView *)tableFooterView
{
    if (!_tableFooterView) {
        _tableFooterView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
            [view setBackgroundColor:[UIColor whiteColor]];
            view;
        });
    }
    return _tableFooterView;
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
