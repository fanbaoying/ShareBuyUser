//
//  UserDetailsViewController.m
//  ShareBuyUser
//
//  Created by 刘兵 on 16/8/12.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "UserDetailsViewController.h"
#import "UserDetailsTableViewCell.h"
#import "DirectMessagesViewController.h"
#import "ShareDetailsViewController.h"

@interface UserDetailsViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UILabel *nameLabel;
    UILabel *numLabel;
    UIImageView *headImg;
    NSMutableArray *dataArray;
    NSInteger pageIndex;
}
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation UserDetailsViewController

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.nav.alphaView setAlpha:0];
    
    [dataArray removeAllObjects];
    pageIndex = 1;
    [self getCommunityListWithDict:@{@"pageSize":@"10",@"pageIndex":@(pageIndex),@"userid":_userID}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataArray = [NSMutableArray array];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 0, 50, 35);
    [btn setTitle:@"私信Ta" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = UIFontPingFangMedium(14);
    [btn addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
    
    [self.view addSubview:self.tableView];
    
    [self getTopicAppraiseUserInfoWithDict:@{@"userid":_userID}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Get Method

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -64, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self createTableHeader];
        
        [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    }
    return _tableView;
}

#pragma mark - Action
- (void)loadMoreData {
    NSLog(@"loadMoreData");
    pageIndex++;
    [self getCommunityListWithDict:@{@"pageSize":@"10",@"pageIndex":@(pageIndex),@"userid":_userID}];
}
- (void)tap:(UITapGestureRecognizer *)tap {
    NSLog(@"tag%ld", [[tap.view superview] tag]);
    ShareDetailsViewController *vc = [[ShareDetailsViewController alloc] init];
    vc.shareDic = dataArray[[[tap.view superview] tag]-100];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)rightItemClick {
    NSLog(@"私信他");
    DirectMessagesViewController *vc = [[DirectMessagesViewController alloc] init];
    vc.recipientID = _userID;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)createTableHeader {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200*kWR)];
    view.backgroundColor = UIColorFromHex(0xff8d51, 1);
    
    UIImageView *backImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200*kWR)];
    backImg.image = [UIImage imageNamed:@"mine_header_bg_image"];
    [view addSubview:backImg];
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 35*kWR, kScreenWidth - 100, 20)];
    nameLabel.text = @"李欣";
    nameLabel.font = UIFontPingFangMedium(18);
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:nameLabel];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 74*kWR)/2, CGRectGetMaxY(nameLabel.frame)+15*kWR, 74*kWR, 74*kWR)];
    img.image = [UIImage imageNamed:@"userDetails_headback"];
    [view addSubview:img];
    
    headImg = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, CGRectGetWidth(img.frame) - 8, CGRectGetWidth(img.frame) - 8)];
    headImg.backgroundColor = [UIColor greenColor];
    headImg.layer.cornerRadius = (CGRectGetWidth(img.frame) - 8)/2;
    headImg.layer.masksToBounds = YES;
    [img addSubview:headImg];
    
    numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(view.frame) - 40, kScreenWidth, 40)];
    numLabel.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    numLabel.font = UIFontPingFangMedium(16);
    numLabel.textColor = [UIColor whiteColor];
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.text = @"评论过：41次";
    [view addSubview:numLabel];
    
    _tableView.tableHeaderView = view;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell";
    UserDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UserDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.model = dataArray[indexPath.section];
    cell.tag = indexPath.section + 100;

    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [cell.imgScorllView addGestureRecognizer:tapGes];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CGRectGetHeight([self tableView:tableView cellForRowAtIndexPath:indexPath].frame);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ShareDetailsViewController *vc = [[ShareDetailsViewController alloc] init];
    vc.shareDic = dataArray[indexPath.section];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Networking
//社区查询帖子用户详情   
- (void)getTopicAppraiseUserInfoWithDict:(NSDictionary *)dict
{
    [self showHudInView:self.view hint:nil];
    [DDPBLL requestWithURL:DEF_URL_TopicAppraiseUserInfo  Dict:dict result:^(NSDictionary *responseDict) {
        [self hideHud];
        NSLog(@"%@",responseDict);
        if (responseDict == nil) {
            return ;
        }
        if ([[responseDict objectForKey:@"status"] integerValue] == 0) {
            NSLog(@"获取用户详情成功");
            [nameLabel setText:responseDict[@"data"][@"nickname"]];
            [headImg setImageWithURL:[NSURL URLWithString:responseDict[@"data"][@"headurl"]] placeholderImage:[UIImage imageNamed:@"product_placeholder"]];
            [numLabel setText:[NSString stringWithFormat:@"评论过：%@次",responseDict[@"data"][@"number"]]];
        }
        else{
            [self showHint:responseDict[@"msg"]];
        }
    }];
}

- (void)getCommunityListWithDict:(NSDictionary *)dict {
//    [self showHudInView:self.view hint:nil];
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

@end
