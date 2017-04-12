//
//  ShareListViewController.m
//  ShareBuyUser
//
//  Created by soldier on 16/8/24.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "ShareListViewController.h"
#import "ShareCell.h"
#import "ShareDetailsViewController.h"

@interface ShareListViewController () <UITableViewDelegate,UITableViewDataSource>
{
    NSInteger currentPage;
}

@property (nonatomic, strong) UITableView *shareTableView;
@property (nonatomic, strong) NSMutableArray *shareArray;

@end

@implementation ShareListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"我的分享"];
    
    self.shareArray = [NSMutableArray array];
    [self.view addSubview:self.shareTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.shareArray = [NSMutableArray array];
    currentPage = 0;
    NSDictionary *dic = @{@"pageIndex":[NSString stringWithFormat:@"%ld",currentPage+1],@"pageSize":@"10",@"token":[UserModel shareUserModel].userToken};
    [self getCommunityListWithDict:dic];
}

- (UITableView *)shareTableView
{
    if (!_shareTableView) {
        _shareTableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHight) style:UITableViewStylePlain];
            [tableView setDelegate:self];
            [tableView setDataSource:self];
            [tableView setBackgroundColor:[UIColor clearColor]];
            [tableView setTableFooterView:[UIView new]];
//            [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            [tableView setSeparatorInset:UIEdgeInsetsZero];
            [tableView setLayoutMargins:UIEdgeInsetsZero];
            
            [tableView addLegendFooterWithRefreshingBlock:^{
                currentPage++;
                NSDictionary *dic = @{@"pageIndex":[NSString stringWithFormat:@"%ld",currentPage+1],@"pageSize":@"10",@"token":[UserModel shareUserModel].userToken};
                [self getCommunityListWithDict:dic];
            }];
            
            tableView;
        });
    }
    return _shareTableView;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShareCell *cell = (ShareCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return CGRectGetHeight(cell.frame);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"选择cell");
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_shareArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ShareCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[ShareCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsZero];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.model = _shareArray[indexPath.row];
    cell.tag = indexPath.row + 100;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImg:)];
    [cell.imgScorllView addGestureRecognizer:tapGes];
    
    return cell;
}

- (void)tapImg:(UITapGestureRecognizer *)tap {
    NSLog(@"tag%ld", [[[tap.view superview] superview] tag]);
    ShareDetailsViewController *vc = [[ShareDetailsViewController alloc] init];
    vc.shareDic = _shareArray[[[[tap.view superview] superview] tag]-100];
    vc.isMine = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - network
- (void)getCommunityListWithDict:(NSDictionary *)dict {
    [self showHudInView:self.view hint:nil];
    [DDPBLL requestWithURL:DEF_URL_GetCommunityList Dict:dict result:^(NSDictionary *responseDict) {
        if (responseDict == nil) {
            return ;
        }
        [self hideHud];
        if ([responseDict[@"status"] integerValue] == 0) {
            if ([responseDict[@"data"] count] > 0) {
                [self.shareArray addObjectsFromArray:responseDict[@"data"]];
            }
            else {
                // legendFooter置为"没有更多内容了"状态
                [_shareTableView.legendFooter noticeNoMoreData];
            }
            [_shareTableView reloadData];
        }
        else {
            [self showHint:responseDict[@"msg"] yOffset:0];
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
