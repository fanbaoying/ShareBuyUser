//
//  MineViewController.m
//  ShareBuyUser
//
//  Created by soldier on 16/8/8.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "MineViewController.h"
#import "BaseTabBarController.h"

#import "MineTableViewHeaderView.h"
#import "MineTableViewCell.h"

#import "LoginViewController.h"

#import "OrderListViewController.h"
#import "AddressManagementViewController.h"
#import "SettingViewController.h"
#import "MessageListViewController.h"
#import "CollectionViewController.h"
#import "PersonalInfoViewController.h"
#import "ShareListViewController.h"

@interface MineViewController () <UITableViewDelegate,UITableViewDataSource,MineTableViewHeaderViewDelegate>

@property(nonatomic)UITableView *mineTableView;
@property(nonatomic,copy)NSArray *mineArray;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self customView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [[BaseTabBarController shareTabBarController].title setAlpha:0];
    [[BaseTabBarController shareTabBarController] setTitle:@""];
    [self.nav.alphaView setAlpha:0];
    if ([UserModel ifLogin]) {
        [self requestUserInfoData];
    }else{
        MineTableViewHeaderView *headerView = (MineTableViewHeaderView *)[_mineTableView headerViewForSection:0];
        [headerView.loginButton setHidden:NO];
        [headerView.nickLabel setHidden:YES];
        [headerView.nickLabel setText:@""];
        [headerView.bgImageView setImage:[UIImage imageNamed:@"mine_header_bg_image"]];
        [headerView.userAvatarImageView setImageWithURL:[NSURL URLWithString:[UserModel shareUserModel].userAvatar] placeholderImage:[UIImage imageNamed:@"mine_avatar_placeholder_image"]];
    }
}

#pragma mark Request Data
- (void)requestUserInfoData
{
    NSDictionary *dict = @{@"token":[UserModel shareUserModel].userToken};
    
    [self showHudInView:self.view hint:nil];
    [DDPBLL requestWithURL:DEF_URL_GetUserInfo  Dict:dict result:^(NSDictionary *responseDict) {
        [self hideHud];
        if (responseDict == nil) {
            [self showHint:@"获取用户信息失败"];
            return ;
        }
        if ([[responseDict objectForKey:@"status"] integerValue]==0) {
            [[UserModel shareUserModel] setUserID:responseDict[@"data"][@"userid"]];
            [[UserModel shareUserModel] setUserNick:responseDict[@"data"][@"nickname"]];
            [[UserModel shareUserModel] setUserAvatar:responseDict[@"data"][@"headurl"]];
            [[UserModel shareUserModel] setUserPhone:responseDict[@"data"][@"phone"]];
//            [_mineTableView reloadData];
            MineTableViewHeaderView *headerView = (MineTableViewHeaderView *)[_mineTableView headerViewForSection:0];
            [headerView.bgImageView setImageWithURL:[NSURL URLWithString:[UserModel shareUserModel].userAvatar] placeholderImage:[UIImage imageNamed:@"mine_header_bg_image"]];
            [headerView.userAvatarImageView setImageWithURL:[NSURL URLWithString:[UserModel shareUserModel].userAvatar] placeholderImage:[UIImage imageNamed:@"mine_header_bg_image"]];
            [headerView.loginButton setHidden:YES];
            [headerView.nickLabel setHidden:NO];
            [headerView.nickLabel setText:[UserModel shareUserModel].userNick];
        }else{
            [self showHint:responseDict[@"msg"]];
        }
    }];
}


#pragma mark Init Data
- (void)initData
{
//    _mineArray = @[@"我的账户",@"我的订单",@"我的收藏",@"我的分享",@"收货地址管理"];
    _mineArray = @[@{@"title":@"我的账户",@"image":@"mine_account_image"},@{@"title":@"我的订单",@"image":@"mine_order_image"},@{@"title":@"我的收藏",@"image":@"mine_collection_image"},@{@"title":@"我的分享",@"image":@"mine_share_image"},@{@"title":@"收货地址管理",@"image":@"mine_address_image"}];
}

#pragma mark Custom View
- (void)customView
{
    [self.view addSubview:self.mineTableView];
}

- (UIBarButtonItem *)settingBarButtonItem
{
    if (!_settingBarButtonItem) {
        _settingBarButtonItem = ({
            UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"mine_barbuttonitem_setting_image"] style:UIBarButtonItemStylePlain target:self action:@selector(selectSettingBarButton:)];
            barButtonItem;
        });
    }
    return _settingBarButtonItem;
}

- (UIBarButtonItem *)messageBarButtonItem
{
    if (!_messageBarButtonItem) {
        _messageBarButtonItem = ({
            UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"mine_barbuttonitem_message_image"] style:UIBarButtonItemStylePlain target:self action:@selector(selectMessageBarButton:)];
            barButtonItem;
        });
    }
    return _messageBarButtonItem;
}

- (UITableView *)mineTableView
{
    if (!_mineTableView) {
        _mineTableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kTabbarHight) style:UITableViewStylePlain];
            [tableView setDelegate:self];
            [tableView setDataSource:self];
            [tableView setBackgroundColor:[UIColor clearColor]];
            tableView.tableFooterView = [UIView new];
            [tableView setScrollEnabled:NO];
            [tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
            
            tableView;
        });
    }
    return _mineTableView;
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 200*kWR +5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *headerID = @"MineHeader";
    MineTableViewHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
    if (!headerView) {
        headerView = [[MineTableViewHeaderView alloc] initWithReuseIdentifier:headerID];
        [headerView setFrame:CGRectMake(0, 0, kScreenWidth, 200*kWR+5)];
        [headerView setDelegate:self];
        if ([UserModel ifLogin]) {
            [headerView.loginButton setHidden:YES];
            [headerView.nickLabel setHidden:NO];
            [headerView.nickLabel setText:[UserModel shareUserModel].userNick];
        }else{
            [headerView.loginButton setHidden:NO];
            [headerView.nickLabel setHidden:YES];
        }
    }
    
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"MineCell";
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[MineTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setDic:_mineArray[indexPath.row]];
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![UserModel ifLogin]) {
        [self presentViewController:[[BaseNavController alloc] initWithRootViewController:[LoginViewController new]] animated:YES completion:^{
        }];
        return;
    }
    
    switch (indexPath.row) {
        case 0:
            
            break;
        case 1:
        {
            NSLog(@"订单");
            [self.navigationController pushViewController:[OrderListViewController new] animated:YES];
        }
            break;
        case 2:
            NSLog(@"收藏");
            [self.navigationController pushViewController:[CollectionViewController new] animated:YES];
            break;
        case 3:
            NSLog(@"分享");
            [self.navigationController pushViewController:[ShareListViewController new] animated:YES];
            break;
        case 4:
        {
            NSLog(@"地址");
            AddressManagementViewController *vc = [AddressManagementViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}


#pragma mark MineTableViewHeaderViewDelegate
- (void)selectLoginButtonWithMineTableViewHeader:(MineTableViewHeaderView *)headerView
{
    [self presentViewController:[[BaseNavController alloc] initWithRootViewController:[LoginViewController new]] animated:YES completion:^{
        
    }];
}

- (void)selectPersonalInfo
{
    NSLog(@"跳转至个人资料");
    if ([UserModel ifLogin]) {
        [self.navigationController pushViewController:[PersonalInfoViewController new] animated:YES];
    }else
    {
        [self presentViewController:[[BaseNavController alloc] initWithRootViewController:[LoginViewController new]] animated:YES completion:^{
        }];
    }
}

#pragma mark Button Action
- (IBAction)selectSettingBarButton:(id)sender
{
    if ([UserModel ifLogin]) {
        [self.navigationController pushViewController:[SettingViewController new] animated:YES];
    }
    else {
        [self presentViewController:[[BaseNavController alloc] initWithRootViewController:[LoginViewController new]] animated:YES completion:^{
        }];
    }
}

- (void)selectMessageBarButton:(UIButton *)sender
{
    if ([UserModel ifLogin]) {
        [self.navigationController pushViewController:[MessageListViewController new] animated:YES];
    }else
    {
        [self presentViewController:[[BaseNavController alloc] initWithRootViewController:[LoginViewController new]] animated:YES completion:^{
        }];
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
