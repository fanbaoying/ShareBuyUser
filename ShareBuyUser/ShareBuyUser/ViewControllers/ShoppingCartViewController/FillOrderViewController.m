//
//  FillOrderViewController.m
//  ShareBuyUser
//
//  Created by soldier on 16/8/18.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "FillOrderViewController.h"
#import "WriteOrderTableViewCell.h"
#import "OrderPayViewController.h"
#import "AddressManagementViewController.h"

@interface FillOrderViewController () <UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSMutableArray *pickerViewDataArray;
    NSInteger selectedIndex;
    
    UIView *pickerTopView;
    UIPickerView *pickerView;
    UILabel *totalLabel;
    UILabel *remindLabel;
    
    NSMutableDictionary *addressDict;            //收货地址Dic
    float freightMoney;
    float money;
}

@property (nonatomic, strong) UITableView *fillOrderTableView;
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *addressLabel;

@end

@implementation FillOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"填写订单"];
    
    [self.view addSubview:self.fillOrderTableView];
    
    [self createFooter];
    [self createPicker];
    
    freightMoney = 0;
    pickerViewDataArray = [NSMutableArray array];
    selectedIndex = -1;
    
    NSDictionary *dic = @{@"token":[UserModel shareUserModel].userToken};
    [self getUserAddressRequestWithDict:dic];
    
    for (int i = 0; i<[_goodsArray count]; i++) {
        for (int j = 0; j<[_goodsArray[i][@"goodsArray"] count]; j++) {
            money += [_goodsArray[i][@"goodsArray"][j][@"goodsInfo"][@"onprice"] floatValue] *[_goodsArray[i][@"goodsArray"][j][@"goodsNum"] integerValue];
        }
    }
    
}

#pragma mark - Get Method
- (UITableView *)fillOrderTableView
{
    if (!_fillOrderTableView) {
        _fillOrderTableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHight-50) style:UITableViewStyleGrouped];
            [tableView setDelegate:self];
            [tableView setDataSource:self];
            tableView.tableHeaderView = self.tableHeaderView;
            
            
            tableView;
        });
    }
    return _fillOrderTableView;
}

- (UIView *)tableHeaderView
{
    if (!_tableHeaderView) {
        _tableHeaderView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
            [view setBackgroundColor:[UIColor clearColor]];
            
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, kScreenWidth, 90)];
            [bgView setBackgroundColor:[UIColor whiteColor]];
            [view addSubview:bgView];
            
            UILabel *nameTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60, 45)];
            nameTitleLabel.text = @"收货人：";
            nameTitleLabel.font = UIFontPingFangMedium(14);
            [bgView addSubview:nameTitleLabel];
            
            UILabel *phoneTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 0, 80, 45)];
            phoneTitleLabel.text = @"联系电话：";
            phoneTitleLabel.font = UIFontPingFangMedium(14);
            [phoneTitleLabel setTextAlignment:NSTextAlignmentRight];
            [bgView addSubview:phoneTitleLabel];
            
            UILabel *addressTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, 50, 45)];
            addressTitleLabel.text = @"地址:";
            addressTitleLabel.font = UIFontPingFangMedium(14);
            [bgView addSubview:addressTitleLabel];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, 44.5, kScreenWidth-50, 0.5)];
            [lineView setBackgroundColor:UIColorFromHex(0xbbbbbb, 1)];
            [bgView addSubview:lineView];
            
            UIImageView *arrowImgV = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-20, 35, 10, 20)];
            [arrowImgV setImage:[UIImage imageNamed:@"cell_arrow_right_image"]];
            [bgView addSubview:arrowImgV];
            
            [bgView addSubview:self.nameLabel];
            [bgView addSubview:self.phoneLabel];
            [bgView addSubview:self.addressLabel];
            
            //添加手势，点击屏幕其他区域关闭键盘的操作
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseAddr:)];
            [bgView addGestureRecognizer:gesture];
            
            view;
        });
    }
    return _tableHeaderView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 70, 45)];
            [label setFont:UIFontPingFangMedium(14.0f)];
            [label setTextColor:UIColorFromHex(0x5d5d5d, 1)];
            
            label;
        });
    }
    return _nameLabel;
}

- (UILabel *)phoneLabel
{
    if (!_phoneLabel) {
        _phoneLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(230, 0, kScreenWidth-240, 45)];
            [label setFont:UIFontPingFangMedium(14.0f)];
            [label setTextColor:UIColorFromHex(0x5d5d5d, 1)];
            
            label;
        });
    }
    return _phoneLabel;
}

- (UILabel *)addressLabel
{
    if (!_addressLabel) {
        _addressLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60, 45, kScreenWidth-90, 45)];
            [label setFont:UIFontPingFangMedium(14.0f)];
            [label setTextAlignment:NSTextAlignmentRight];
            [label setTextColor:UIColorFromHex(0x5d5d5d, 1)];
            
            label;
        });
    }
    return _addressLabel;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.goodsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.goodsArray[section][@"goodsArray"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    WriteOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[WriteOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        cell.delegate = self;
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsZero];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell.nameLabel setText:_goodsArray[indexPath.section][@"goodsArray"][indexPath.row][@"goodsInfo"][@"goodsname"]];
    [cell.priceLabel setText:[NSString stringWithFormat:@"￥%.2f",[_goodsArray[indexPath.section][@"goodsArray"][indexPath.row][@"goodsInfo"][@"onprice"] floatValue]]];
    [cell.numLabel setText:[NSString stringWithFormat:@"%@",_goodsArray[indexPath.section][@"goodsArray"][indexPath.row][@"goodsNum"]]];
    [cell.img setImageWithURL:[NSURL URLWithString:_goodsArray[indexPath.section][@"goodsArray"][indexPath.row][@"goodsInfo"][@"imgurl"]] placeholderImage:[UIImage imageNamed:@"product_placeholder"]];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40.0f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, kScreenWidth, 35)];
    [label setBackgroundColor:[UIColor whiteColor]];
    [label setFont:UIFontPingFangMedium(14.0f)];
    label.text = @"大奥莱超市";
    
    if ([_goodsArray[section][@"goodsArray"][0][@"goodsInfo"][@"businessname"] length] == 0) {
        [label setText:@"  分享购自营"];
    }else
    {
        [label setText:[NSString stringWithFormat:@"  %@",_goodsArray[section][@"goodsArray"][0][@"goodsInfo"][@"businessname"]]];
    }
    [view addSubview:label];
    
    return view;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 140, 0, 50, 40)];
    label.text = @"快递：";
    label.font = UIFontPingFangMedium(14);
    [view addSubview:label];
    
    UIButton *courierBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), 5, 80, 30)];
    courierBtn.backgroundColor = UIColorFromHex(0xf2f2f2, 1);
    [courierBtn setImage:[UIImage imageNamed:@"selectShopping_downArrow"] forState:UIControlStateNormal];
    [courierBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -80)];
    [courierBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
    courierBtn.layer.cornerRadius = 5;
    courierBtn.layer.masksToBounds = YES;
    courierBtn.layer.borderWidth = 1;
    courierBtn.layer.borderColor = UIColorFromHex(0xbbbbbb, 1).CGColor;
    courierBtn.titleLabel.font = UIFontPingFangLight(13);
    courierBtn.tag = 100+section;
    [courierBtn setTitle:_goodsArray[section][@"freight"][@"expresscompanyname"] forState:UIControlStateNormal];
    [courierBtn setTitleColor:UIColorFromHex(0x9a9a9a, 1) forState:UIControlStateNormal];
    [courierBtn addTarget:self action:@selector(selectCourier:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:courierBtn];
    
    return view;

}

#pragma mark - Action
- (void)chooseAddr:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"选择收货地址");
    AddressManagementViewController *addressManageVC = [[AddressManagementViewController alloc] init];
    [addressManageVC chooseAddress:^(NSDictionary *addressDic) {
        NSLog(@"选取收货地址");
        addressDict = [NSMutableDictionary dictionaryWithDictionary:addressDic];
        [_nameLabel setText:addressDic[@"name"]];
        [_phoneLabel setText:addressDic[@"phone"]];
        [_addressLabel setText:addressDic[@"address"]];
        
        [self CalculateFreight];
    }];
    [self.navigationController pushViewController:addressManageVC animated:YES];
}

- (void)createPicker {
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 64 - 162, kScreenWidth, 162)];
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.dataSource = self;
    pickerView.delegate = self;
    [self.view addSubview:pickerView];
    pickerView.hidden = YES;
    
    pickerTopView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(pickerView.frame)-40, kScreenWidth, 40)];
    pickerTopView.backgroundColor = [UIColor grayColor];
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 50, 40)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = UIFontPingFangMedium(15);
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [pickerTopView addSubview:cancelBtn];
    
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 60, 0, 50, 40)];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = UIFontPingFangMedium(15);
    [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [pickerTopView addSubview:confirmBtn];
    pickerTopView.hidden = YES;
    [self.view addSubview:pickerTopView];
}

- (void)confirmBtnClick {
    pickerTopView.hidden = YES;
    pickerView.hidden = YES;
    NSInteger row = [pickerView selectedRowInComponent:0];
    
    [_goodsArray[selectedIndex] setValue:pickerViewDataArray[row] forKey:@"freight"];
//    [array replaceObjectAtIndex:selectedIndex withObject:pickerViewDataArray[row]];
    [_fillOrderTableView reloadData];
    
    if (addressDict == nil) {
        [self showHint:@"请选择地址" yOffset:-250];
        return;
    }
    
    [self CalculateFreight];
}

- (void)cancelBtnClick {
    pickerTopView.hidden = YES;
    pickerView.hidden = YES;
}

- (void)createFooter {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 45 - 64, kScreenWidth, 45)];
    footerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footerView];
    
    totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 140, 20)];
    totalLabel.font = UIFontPingFangMedium(14);
//    NSString *str = @"合计：¥2000";
    NSString *str = [NSString stringWithFormat:@"合计：￥%.2f",money+freightMoney];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attStr addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0xff5f3b, 1) range:NSMakeRange(3, str.length - 3)];
    totalLabel.attributedText = attStr;
    totalLabel.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:totalLabel];
    
    remindLabel = [[UILabel alloc] initWithFrame:CGRectOffset(totalLabel.frame, 0, CGRectGetHeight(totalLabel.frame)+5)];
    remindLabel.font = UIFontPingFangMedium(13);
    remindLabel.textColor = UIColorFromHex(0x969696, 1);
//    remindLabel.text = @"（其中运费¥10）";
    [remindLabel setText:[NSString stringWithFormat:@"（其中运费¥%.2f）",freightMoney]];
    remindLabel.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:remindLabel];
    
    UIButton *bottomBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(remindLabel.frame), 0, 140, 45)];
    bottomBtn.backgroundColor = UIColorFromHex(0xff5f3b, 1);
    [bottomBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    [bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bottomBtn.titleLabel.font = UIFontPingFangMedium(15);
    [bottomBtn addTarget:self action:@selector(commitClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:bottomBtn];
}

#pragma mark - UIPickerViewDelegate, UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return pickerViewDataArray.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return pickerViewDataArray[row][@"expresscompanyname"];
}

#pragma mark - UIButton Action
- (void)commitClick {
    NSLog(@"提交订单");

    NSString *goodsInfoStr = @"";
    for (int i = 0; i<[_goodsArray count]; i++) {
        for (int j = 0; j<[_goodsArray[i][@"goodsArray"] count]; j++) {
            goodsInfoStr = [goodsInfoStr stringByAppendingFormat:@"%@@%@@%@#",_goodsArray[i][@"goodsArray"][j][@"goodsInfo"][@"goodsid"],_goodsArray[i][@"goodsArray"][j][@"goodsNum"],_goodsArray[i][@"freight"][@"freightid"]];
        }
    }
    
    if (_shareID == nil) {
        _shareID = @"0";
    }
    NSDictionary *dic = @{@"token":[UserModel shareUserModel].userToken,@"goodsinfo":goodsInfoStr,@"useraddressid":addressDict[@"useraddressid"],@"ispay":@"0",@"shareid":_shareID};
    [self createOrderRequestWithDict:dic];
}

- (void)selectCourier:(UIButton *)btn {
    NSLog(@"选择快递%ld", btn.tag - 100);
    pickerTopView.hidden = NO;
    pickerView.hidden = NO;
    selectedIndex = btn.tag - 100;
}

//计算运费
- (void)CalculateFreight
{
    for (int i = 0; i<[_goodsArray count]; i++) {
        NSLog(@"%@",_goodsArray[i]);
        NSString *goodsIdStr = @"";
        NSString *goodsNumStr = @"";
        freightMoney = 0;
        
        for (int j = 0; j<[_goodsArray[i][@"goodsArray"] count]; j++) {
            goodsIdStr = [goodsIdStr stringByAppendingFormat:@"%@,",_goodsArray[i][@"goodsArray"][j][@"goodsInfo"][@"goodsid"]];
            goodsNumStr = [goodsNumStr stringByAppendingFormat:@"%@,",_goodsArray[i][@"goodsArray"][j][@"goodsNum"]];

        }
        NSDictionary *dic = @{@"goodsid":goodsIdStr,@"goodscount":goodsNumStr,@"freightid":_goodsArray[i][@"freight"][@"freightid"],@"countyid":addressDict[@"countryid"]};
        [self findFreightRequestWithDict:dic];
    }

}


#pragma mark - NetWorking
//获取地址，并筛选出默认地址
- (void)getUserAddressRequestWithDict:(NSDictionary *)dict
{
    [self showHudInView:self.view hint:nil];
    [DDPBLL requestWithURL:DEF_URL_GetAddressList  Dict:dict result:^(NSDictionary *responseDict) {
        [self hideHud];
        NSLog(@"%@",responseDict);
        if (responseDict == nil) {
            return ;
        }
        if ([[responseDict objectForKey:@"status"] integerValue] == 0) {
            for (NSDictionary *dic in responseDict[@"data"]) {
                if ([dic[@"isdefault"] integerValue] == 1) {
                    addressDict = [NSMutableDictionary dictionaryWithDictionary:dic];
                    [_nameLabel setText:dic[@"name"]];
                    [_phoneLabel setText:dic[@"phone"]];
                    [_addressLabel setText:dic[@"address"]];
                }
            }
            [self findFreightInfoRequest];
        }
        else{
            [self showHint:responseDict[@"msg"]];
        }
    }];
}

//查询运费模板
- (void)findFreightInfoRequest
{
    //    [self showHudInView:self.view hint:nil];
    [DDPBLL requestWithURL:DEF_URL_FindFreightInfo  Dict:nil result:^(NSDictionary *responseDict) {
        [self hideHud];
        NSLog(@"%@",responseDict);
        if (responseDict == nil) {
            return ;
        }
        if ([[responseDict objectForKey:@"status"] integerValue] == 0) {
            pickerViewDataArray = responseDict[@"data"];
            
            NSLog(@"%@",_goodsArray);
            for (int i = 0; i<[_goodsArray count]; i++) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:_goodsArray[i]];
                [dic setValue:pickerViewDataArray[0] forKey:@"freight"];
                [_goodsArray replaceObjectAtIndex:i withObject:dic];
            }
            [pickerView reloadComponent:0];
            [_fillOrderTableView reloadData];
            
            if (addressDict != nil) {
                [self CalculateFreight];
            }
        }
        else{
            [self showHint:responseDict[@"msg"]];
        }
    }];
}

//查询运费
- (void)findFreightRequestWithDict:(NSDictionary *)dict
{
    [DDPBLL requestWithURL:DEF_URL_FindFreight  Dict:dict result:^(NSDictionary *responseDict) {
        [self hideHud];
        NSLog(@"%@",responseDict);
        if (responseDict == nil) {
            return ;
        }
        if ([[responseDict objectForKey:@"status"] integerValue] == 0) {
            freightMoney += [responseDict[@"data"][@"money"] floatValue];
            NSString *str = [NSString stringWithFormat:@"合计：￥%.2f",money+freightMoney];
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
            [attStr addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0xff5f3b, 1) range:NSMakeRange(3, str.length - 3)];
            totalLabel.attributedText = attStr;
            totalLabel.textAlignment = NSTextAlignmentCenter;
            
            [remindLabel setText:[NSString stringWithFormat:@"（其中运费¥%.2f）",freightMoney]];
        }
        else{
            [self showHint:responseDict[@"msg"]];
        }
    }];
}

//提交订单
- (void)createOrderRequestWithDict:(NSDictionary *)dict
{
    [DDPBLL requestWithURL:DEF_URL_CreateOrder  Dict:dict result:^(NSDictionary *responseDict) {
        [self hideHud];
        NSLog(@"%@",responseDict);
        if (responseDict == nil) {
            return ;
        }
        if ([[responseDict objectForKey:@"status"] integerValue] == 0) {
            NSLog(@"提交订单成功");
            //如果 从购物车 进入 ，清空购物车
            if (_isShopCartOrder) {
                NSLog(@"清空本地购物车");
                //如果购物车提交订单成功,清空该用户userid下的本地购物车数据
                if ([ReadWriteSandbox propertyFileExists:ShopCart_File_Path]) {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[ReadWriteSandbox readPropertyFile:ShopCart_File_Path]];
                    NSMutableArray *cartArray = [NSMutableArray arrayWithArray:dic[@"data"]];
                    for (int i = 0; i<[cartArray count]; i++) {
                        if ([cartArray[i][@"userToken"] isEqual:[UserModel shareUserModel].userToken]) {
                            for (int j = 0; j<[cartArray[i][@"goodsArray"] count]; j++) {
                                if ([cartArray[i][@"goodsArray"][j][@"isCheck"] integerValue] == 1) {
                                    [cartArray[i][@"goodsArray"] removeObjectAtIndex:j];
                                    j--;
                                }
                            }
                            if ([cartArray[i][@"goodsArray"] count] == 0) {
                                [cartArray removeObjectAtIndex:i];
                                i--;
                            }
                        }
                    }
                    [dic setValue:cartArray forKey:@"data"];
                    [ReadWriteSandbox writePropertyFile:dic FilePath:ShopCart_File_Path];
                }
            }
            
            //跳转到订单支付页面
            OrderPayViewController *orderPayVC = [[OrderPayViewController alloc] init];
            [orderPayVC setTitle:@"支付"];
            orderPayVC.orderType = _orderType;
//            NSString *payPrice = [NSString stringWithFormat:@"%.2f",money+freightMoney];
//            NSDictionary *dic = @{@"orderid":responseDict[@"data"][@"orderid"],@"payprice":payPrice};
            orderPayVC.orderDic = responseDict[@"data"];
            orderPayVC.shareID = _shareID;
            [self.navigationController pushViewController:orderPayVC animated:YES];
        }
        else{
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
