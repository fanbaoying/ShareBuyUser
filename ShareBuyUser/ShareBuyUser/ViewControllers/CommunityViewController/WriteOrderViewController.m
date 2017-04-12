//
//  WriteOrderViewController.m
//  ShareBuyUser
//
//  Created by 刘兵 on 16/8/10.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "WriteOrderViewController.h"
#import "WriteOrderTopCell.h"
#import "WriteOrderTableViewCell.h"

@interface WriteOrderViewController ()<UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource>
{
    UILabel *totalLabel;
    UILabel *remindLabel;
    
    UIPickerView *pickerView;
    UIView *pickerTopView;
    NSMutableArray *pickerViewDataArray;
    NSMutableArray *array;
    NSInteger selectedIndex;
    
    NSMutableDictionary *addressDic;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation WriteOrderViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"填写订单";
    [self.view addSubview:self.tableView];
    [self createFooter];
    
    [self createPicker];
    pickerViewDataArray = [NSMutableArray array];
    array = [NSMutableArray array];
    selectedIndex = -1;
    
    NSDictionary *dic = @{@"token":[UserModel shareUserModel].userToken};
    [self getUserAddressRequestWithDict:dic];
    
    [self findFreightInfoRequest];
}

#pragma mark - Get Method

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 45) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

#pragma mark - Action

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
    [array replaceObjectAtIndex:selectedIndex withObject:pickerViewDataArray[row]];
    [_tableView reloadData];
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
    NSString *str = @"合计：¥2000";
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attStr addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0xff5f3b, 1) range:NSMakeRange(3, str.length - 3)];
    totalLabel.attributedText = attStr;
    totalLabel.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:totalLabel];
    
    remindLabel = [[UILabel alloc] initWithFrame:CGRectOffset(totalLabel.frame, 0, CGRectGetHeight(totalLabel.frame)+5)];
    remindLabel.font = UIFontPingFangMedium(13);
    remindLabel.textColor = UIColorFromHex(0x969696, 1);
    remindLabel.text = @"（其中运费¥10）";
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

- (void)commitClick {
    NSLog(@"提交订单");

}

- (void)selectCourier:(UIButton *)btn {
    NSLog(@"选择快递%ld", btn.tag - 100);
    pickerTopView.hidden = NO;
    pickerView.hidden = NO;
    selectedIndex = btn.tag - 100;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_goodsArray count] +1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return [_goodsArray[section-1][@"goodsArray"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        WriteOrderTopCell *cell = [[WriteOrderTopCell alloc] init];
        cell.model = addressDic;
        return cell;
    }
    else {
        static NSString *cellID = @"cell";
        WriteOrderTableViewCell *cell = (WriteOrderTableViewCell *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:cellID];
        if (!cell) {
            cell = [[WriteOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        
        [cell.nameLabel setText:_goodsArray[indexPath.section-1][@"goodsArray"][indexPath.row][@"goodsInfo"][@"goodsname"]];
        [cell.priceLabel setText:[NSString stringWithFormat:@"￥%.2f",[_goodsArray[indexPath.section-1][@"goodsArray"][indexPath.row][@"goodsInfo"][@"onprice"] floatValue]]];
        [cell.numLabel setText:_goodsArray[indexPath.section-1][@"goodsArray"][indexPath.row][@"goodsNum"]];
        [cell.img setImageWithURL:[NSURL URLWithString:_goodsArray[indexPath.section-1][@"goodsArray"][indexPath.row][@"goodsInfo"][@"imgurl"]] placeholderImage:[UIImage imageNamed:@"product_placeholder"]];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 100;
    }
    return 85;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    }
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 0.0001;
    }
    else {
        return 40;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, kScreenWidth, 35)];
        label.backgroundColor = [UIColor whiteColor];
        label.font = UIFontPingFangMedium(14);
        label.text = @"  大奥莱超市";
        
        [label setText:_goodsArray[section-1][@"goodsArray"][0][@"goodsInfo"][@"businessname"]];
        [view addSubview:label];
        return view;
    }
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 140, 0, 50, 40)];
    label.text = @"快递：";
    label.font = UIFontPingFangMedium(14);
    [view addSubview:label];
    
    UIButton *courierBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), 5, 80, 30)];
    courierBtn.backgroundColor = UIColorFromHex(0xf2f2f2, 1);
//    [courierBtn setTitle:array[section] forState:UIControlStateNormal];
    [courierBtn setImage:[UIImage imageNamed:@"selectShopping_downArrow"] forState:UIControlStateNormal];
    [courierBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -80)];
    [courierBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
    courierBtn.layer.cornerRadius = 5;
    courierBtn.layer.masksToBounds = YES;
    courierBtn.layer.borderWidth = 1;
    courierBtn.layer.borderColor = UIColorFromHex(0xbbbbbb, 1).CGColor;
    courierBtn.titleLabel.font = UIFontPingFangLight(13);
    courierBtn.tag = 100+section;
    [courierBtn setTitleColor:UIColorFromHex(0x9a9a9a, 1) forState:UIControlStateNormal];
    [courierBtn addTarget:self action:@selector(selectCourier:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:courierBtn];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSLog(@"地址");
    }
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
                    addressDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
                    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }
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
            array = responseDict[@"data"];
            [pickerView reloadComponent:0];
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


@end
