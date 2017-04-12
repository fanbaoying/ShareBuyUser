//
//  CommunityViewController.m
//  ShareBuyUser
//
//  Created by soldier on 16/8/8.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "CommunityViewController.h"
#import "CommunityTableViewCell.h"
#import "ShareDetailsViewController.h"
#import "UserDetailsViewController.h"

@interface CommunityViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *dataArray;
    NSInteger pageIndex;
}
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CommunityViewController

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
                [dataArray addObjectsFromArray:responseDict[@"data"]];
                [_tableView.footer endRefreshing];
            }
            else {
                [_tableView.footer noticeNoMoreData];
            }
            [_tableView reloadData];
        }
        else {
            [_tableView.footer endRefreshing];
            [self showHint:responseDict[@"msg"] yOffset:0];
        }
    }];
}

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [dataArray removeAllObjects];
    pageIndex = 1;
    [self getCommunityListWithDict:@{@"pageSize":@"10",@"pageIndex":@(pageIndex)}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataArray = [[NSMutableArray alloc] init];
    
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Get Method

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64 - 49) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    }
    return _tableView;
}

#pragma mark - Action

- (void)loadMoreData {
    NSLog(@"loadMoreData");
    pageIndex++;
    [self getCommunityListWithDict:@{@"pageSize":@"10",@"pageIndex":@(pageIndex)}];
}

- (void)tap:(UITapGestureRecognizer *)tap {
    NSLog(@"tag%ld", [[tap.view superview] tag]);
    ShareDetailsViewController *vc = [[ShareDetailsViewController alloc] init];
    vc.shareDic = dataArray[[[tap.view superview] tag]-100];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tapHead:(UITapGestureRecognizer *)tap {
    NSLog(@"用户详情%ld", [[tap.view superview] tag]);
    UserDetailsViewController *vc = [[UserDetailsViewController alloc] init];
    vc.userID = dataArray[[[tap.view superview] tag]-100][@"userid"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate&&UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell";
    CommunityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[CommunityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.model = dataArray[indexPath.section];
    cell.tag = indexPath.section + 100;
    UITapGestureRecognizer *tapHead = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHead:)];
    [cell.headPhotoImg addGestureRecognizer:tapHead];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [cell.imgScorllView addGestureRecognizer:tapGes];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommunityTableViewCell *cell = (CommunityTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return CGRectGetHeight(cell.frame);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ShareDetailsViewController *vc = [[ShareDetailsViewController alloc] init];
    vc.shareDic = dataArray[indexPath.section];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
