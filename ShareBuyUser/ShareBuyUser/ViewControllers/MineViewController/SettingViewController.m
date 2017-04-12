//
//  SettingViewController.m
//  ShareBuyUser
//
//  Created by Marx on 16/8/9.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "SettingViewController.h"

#import "FeedbackViewController.h"

#import "HelpCenterViewController.h"
#import "ResetPasswordViewController.h"

@interface SettingViewController () <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic)UITableView *settingTableView;
@property(nonatomic)NSArray *settingArray;
@property(nonatomic)UIButton *logoffButton;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    
    [self initData];
    [self customView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([UserModel ifLogin]) {
        [_logoffButton setHidden:NO];
    }else{
        [_logoffButton setHidden:YES];
    }
}

#pragma mark Init Data
- (void)initData
{
    _settingArray = @[@"意见反馈",@"关于软件",@"帮助中心",@"修改密码"];
}

#pragma mark Custom View
- (void)customView
{
    [self.view addSubview:self.settingTableView];
    [self.view addSubview:self.logoffButton];
}

- (UITableView *)settingTableView
{
    if (!_settingTableView) {
        _settingTableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHight) style:UITableViewStyleGrouped];
            [tableView setDelegate:self];
            [tableView setDataSource:self];
            [tableView setScrollEnabled:NO];
            [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
            [tableView setSeparatorColor:UIColorFromHex(0xbbbbbb, 1)];
            [tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 10)];
            
            tableView;
        });
    }
    return _settingTableView;
}

- (UIButton *)logoffButton
{
    if (!_logoffButton) {
        _logoffButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(15, kScreenHeight- kNavigationBarHight-70, kScreenWidth -30, 35)];
            [button.layer setMasksToBounds:YES];
            [button.layer setCornerRadius:5];
            [button setBackgroundImage:[UIImage imageWithColor:kMainColor size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
            [button setTitle:@"退出当前用户" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button.titleLabel setFont:UIFontPingFangRegular(15)];
            
            [button addTarget:self action:@selector(selectLogoffButton:) forControlEvents:UIControlEventTouchUpInside];
            
            button;
        });
    }
    return _logoffButton;
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_settingArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"SettingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_arrow_right_image"]];
        [cell.textLabel setFont:UIFontPingFangRegular(15)];
        [cell.textLabel setTextColor:UIColorFromHex(0x3c3c3c, 1)];
    }
    
    [cell.textLabel setText:_settingArray[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            FeedbackViewController *vc = [FeedbackViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            
            break;
        case 1:
            
            break;
        case 2:
        {
            HelpCenterViewController *vc = [HelpCenterViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            ResetPasswordViewController *vc = [ResetPasswordViewController new];
            vc.modifyPass = 1;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark Button Action
- (IBAction)selectLogoffButton:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确认要退出当前账号吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [UserModel logoff];
        [_logoffButton setHidden:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:sureAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:^{
        
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
