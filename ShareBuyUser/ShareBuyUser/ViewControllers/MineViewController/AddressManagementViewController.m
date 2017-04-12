//
//  AddressManagementViewController.m
//  ShareBuyUser
//
//  Created by Marx on 16/8/17.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "AddressManagementViewController.h"
#import "AddressTableViewCell.h"

#import "AddAddressViewController.h"

@interface AddressManagementViewController () <UITableViewDelegate,UITableViewDataSource,AddressTableViewCellDelegate>

@property(nonatomic)UITableView *addressTableView;
@property(nonatomic)NSMutableArray *addressArray;

@property(nonatomic)UIButton *addAddressButton;

@end

@implementation AddressManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"收货地址管理"];
    [self customView];
}

- (void)chooseAddress:(returnBlock)block
{
    self.addressBlock = block;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestAddressData];
}

#pragma mark Request Data
- (void)requestAddressData
{
    NSDictionary *dict = @{@"token":[UserModel shareUserModel].userToken};
    
    [self showHudInView:self.view hint:nil];
    [DDPBLL requestWithURL:DEF_URL_GetAddressList  Dict:dict result:^(NSDictionary *responseDict) {
        [self hideHud];
        NSLog(@"%@",responseDict);
        if (responseDict == nil) {
            //            [self showHint:@"处理失败，请稍后再试"];
            return ;
        }
        if ([[responseDict objectForKey:@"status"] integerValue]==0) {
            _addressArray = [[NSMutableArray alloc] initWithArray:responseDict[@"data"]];
            [_addressTableView reloadData];
        }else{
            [self showHint:responseDict[@"msg"]];
        }
    }];
}

- (void)requestDeleteAddressDataWithDic:(NSDictionary *)dic
{
    NSMutableDictionary *mDic = [[NSMutableDictionary alloc] init];
    [mDic setObject:[UserModel shareUserModel].userToken forKey:@"token"];
    [mDic setObject:dic[@"useraddressid"] forKey:@"useraddressid"];
    [mDic setObject:@"1" forKey:@"isdel"];
    [self showHudInView:self.view hint:nil];
    [DDPBLL requestWithURL:DEF_URL_EditAddress  Dict:mDic result:^(NSDictionary *responseDict) {
        [self hideHud];
        NSLog(@"%@",responseDict);
        if (responseDict == nil) {
            [self showHint:@"处理失败，请稍后再试"];
            return ;
        }
        if ([[responseDict objectForKey:@"status"] integerValue]==0) {
            [self requestAddressData];
        }else{
            [self showHint:responseDict[@"msg"]];
        }
    }];
}

- (void)requestSetDefaultDataWithDic:(NSDictionary *)dic
{
    NSMutableDictionary *mDic = [[NSMutableDictionary alloc] init];
    [mDic setObject:[UserModel shareUserModel].userToken forKey:@"token"];
    [mDic setObject:dic[@"useraddressid"] forKey:@"useraddressid"];
    [mDic setObject:@"1" forKey:@"isdefault"];
    [self showHudInView:self.view hint:nil];
    [DDPBLL requestWithURL:DEF_URL_EditAddress  Dict:mDic result:^(NSDictionary *responseDict) {
        [self hideHud];
        NSLog(@"%@",responseDict);
        if (responseDict == nil) {
            [self showHint:@"处理失败，请稍后再试"];
            return ;
        }
        if ([[responseDict objectForKey:@"status"] integerValue]==0) {
            [self requestAddressData];
//            [_addressTableView reloadData];
        }else{
            [self showHint:responseDict[@"msg"]];
        }
    }];
}

- (void)customView
{
    [self.view addSubview:self.addressTableView];
    [self.view addSubview:self.addAddressButton];
}

- (UITableView *)addressTableView
{
    if (!_addressTableView) {
        _addressTableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHight-55) style:UITableViewStylePlain];
            [tableView setDelegate:self];
            [tableView setDataSource:self];
            [tableView setBackgroundColor:[UIColor clearColor]];
            [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            tableView;
        });
    }
    return _addressTableView;
}

- (UIButton *)addAddressButton
{
    if (!_addAddressButton) {
        _addAddressButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(15, kScreenHeight - kNavigationBarHight - 45, kScreenWidth -30, 35)];
            [button.layer setMasksToBounds:YES];
            [button.layer setCornerRadius:5];
            [button setBackgroundImage:[UIImage imageWithColor:kMainColor size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
            [button setTitle:@"新增地址" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button.titleLabel setFont:UIFontPingFangRegular(15)];
            [button addTarget:self action:@selector(selectAddAddressButton:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _addAddressButton;
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_addressArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 5)];
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"AddressCell";
    AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[AddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    [cell setDelegate:self];
    NSMutableAttributedString *nameString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"收件人：%@",_addressArray[indexPath.section][@"name"]]];
    [nameString addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0x696969, 1) range:NSMakeRange(0, 4)];
    [cell.nameLabel setAttributedText:nameString];
    NSMutableAttributedString *phoneString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"联系电话：%@",_addressArray[indexPath.section][@"phone"]]];
    [phoneString addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0x696969, 1) range:NSMakeRange(0, 5)];
    
    [cell.phoneLabel setAttributedText:phoneString];
    
    [cell.addressLabel setText:_addressArray[indexPath.section][@"address"]];
    if ([_addressArray[indexPath.section][@"isdefault"] integerValue]==1) {
        [cell.defaultButton setSelected:YES];
    }else{
        [cell.defaultButton setSelected:NO];
    }
    
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath

{
    return YES;
}

-(NSString*)tableView:(UITableView*)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath*)indexPath

{
    return @"删除";
}


#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self requestDeleteAddressDataWithDic:_addressArray[indexPath.section]];
        [_addressArray removeObjectAtIndex:indexPath.section];
        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:indexPath.section];
        [tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationRight];
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.addressBlock != nil) {
        self.addressBlock(_addressArray[indexPath.section]);
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        AddAddressViewController *addAddressVC = [[AddAddressViewController alloc] init];
        [addAddressVC setTitle:@"编辑地址"];
        addAddressVC.addressDict = _addressArray[indexPath.section];
        [self.navigationController pushViewController:addAddressVC animated:YES];
    }
}

#pragma mark AddressTableViewCellDelegate
- (void)selectDefaultButtonOnAddressTableViewCell:(AddressTableViewCell *)cell
{
    NSIndexPath *indexPath = [_addressTableView indexPathForCell:cell];
    [self requestSetDefaultDataWithDic:_addressArray[indexPath.section]];
}

- (IBAction)selectAddAddressButton:(id)sender
{
    AddAddressViewController *vc = [AddAddressViewController new];
    [vc setTitle:@"新增地址"];
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
