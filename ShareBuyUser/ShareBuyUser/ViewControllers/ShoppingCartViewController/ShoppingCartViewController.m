//
//  ShoppingCartViewController.m
//  ShareBuyUser
//
//  Created by soldier on 16/8/8.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "ShoppingCartViewController.h"
#import "ShoppingCartCell.h"
//#import "WriteOrderViewController.h"
#import "FillOrderViewController.h"

@interface ShoppingCartViewController () <UITableViewDelegate,UITableViewDataSource,ShoppingCartCellDelegate>

@property (nonatomic, strong) UITableView *shopCartTableView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIImageView *emptyImageView;

@property (nonatomic, strong) UIButton *checkAllButton;
@property (nonatomic, strong) UILabel *totalPriceLabel;
@property (nonatomic, strong) NSMutableArray *localCartGoodsArray;
@property (nonatomic, strong) NSMutableDictionary *localCartDic;            //本地购物车数据

@end

@implementation ShoppingCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.shopCartTableView];
    [self.view addSubview:self.emptyImageView];

    [self.view addSubview:self.bottomView];
    self.navigationItem.rightBarButtonItem = self.clearBarBtnItem;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getLocalShoppingCart];
}

#pragma mark - Get Method
- (UITableView *)shopCartTableView
{
    if (!_shopCartTableView) {
        _shopCartTableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationBarHight, kScreenWidth, kScreenHeight-kNavigationBarHight-kTabbarHight-50) style:UITableViewStyleGrouped];
            [tableView setDelegate:self];
            [tableView setDataSource:self];
            [tableView setBackgroundColor:[UIColor clearColor]];
            [tableView setTableFooterView:[UIView new]];
            [tableView setSeparatorInset:UIEdgeInsetsZero];
            [tableView setLayoutMargins:UIEdgeInsetsZero];
            
            tableView;
        });
    }
    return _shopCartTableView;
}

- (UIImageView *)emptyImageView
{
    if (!_emptyImageView) {
        _emptyImageView = ({
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth -150)/2, (kScreenHeight- kNavigationBarHight - 50 - 200)/2, 150, 200)];
            [imageView setImage:[UIImage imageNamed:@"basket_empty_image"]];
            [_emptyImageView setHidden:YES];
            imageView;
        });
    }
    return _emptyImageView;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-kTabbarHight-50, kScreenWidth, 45)];
            [view setBackgroundColor:[UIColor whiteColor]];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5f)];
            [lineView setBackgroundColor:UIColorFromHex(0xbbbbbb, 1)];
            [view addSubview:lineView];
            
            _checkAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_checkAllButton setBackgroundColor:[UIColor clearColor]];
            [_checkAllButton setFrame:CGRectMake(0, 0, 70, 45)];
            [_checkAllButton setImage:[UIImage imageNamed:@"check_normal"] forState:UIControlStateNormal];
            [_checkAllButton setImage:[UIImage imageNamed:@"check_select"] forState:UIControlStateSelected];
            [_checkAllButton setTitle:@"全选" forState:UIControlStateNormal];
            [_checkAllButton setTitleColor:UIColorFromHex(0xc7c7c7, 1) forState:UIControlStateNormal];
            _checkAllButton.titleLabel.font = UIFontPingFangMedium(11.0f);
            _checkAllButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
            [_checkAllButton addTarget:self action:@selector(clickCheckAllBtn:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:_checkAllButton];
            
            [view addSubview:self.totalPriceLabel];
            
            UIButton *settlementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [settlementBtn setFrame:CGRectMake(kScreenWidth-100, 0, 100, 45)];
            [settlementBtn setBackgroundColor:kMainColor];
            [settlementBtn setTitle:@"结算" forState:UIControlStateNormal];
            settlementBtn.titleLabel.font = UIFontPingFangMedium(14.0f);
            [settlementBtn addTarget:self action:@selector(clickSettlementBtn:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:settlementBtn];
            
            view;
        });
    }
    return _bottomView;
}

- (UIBarButtonItem *)clearBarBtnItem
{
    if (!_clearBarBtnItem) {
        _clearBarBtnItem = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(0, 0, 40, 20)];
            [button setTitle:@"清空" forState:UIControlStateNormal];
            button.titleLabel.font = UIFontPingFangMedium(15.0f);
            [button addTarget:self action:@selector(clickClearShopCart:) forControlEvents:UIControlEventTouchUpInside];
            
            UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:button];
            
            barBtnItem;
        });
    }
    return _clearBarBtnItem;
}

- (UILabel *)totalPriceLabel
{
    if (!_totalPriceLabel) {
        _totalPriceLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, kScreenWidth-270, 45)];
            [label setBackgroundColor:[UIColor clearColor]];
//            [label setText:@"合计：￥0.00"];
            [label setTextAlignment:NSTextAlignmentCenter];
            label.adjustsFontSizeToFitWidth = YES;
            [label setFont:[UIFont systemFontOfSize:13.0f]];
            
            label;
        });
    }
    return _totalPriceLabel;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
    [sectionView setBackgroundColor:[UIColor whiteColor]];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5f)];
    [lineView setBackgroundColor:UIColorFromHex(0xd6d6d6, 1)];
    [sectionView addSubview:lineView];
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, kScreenWidth, 0.5f)];
    [lineView setBackgroundColor:UIColorFromHex(0xd6d6d6, 1)];
    [sectionView addSubview:lineView];
    
    UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkBtn setFrame:CGRectMake(10, 6, 25, 25)];
    [checkBtn setImage:[UIImage imageNamed:@"check_normal"] forState:UIControlStateNormal];
    [checkBtn setImage:[UIImage imageNamed:@"check_select"] forState:UIControlStateSelected];
    
    //判断商户选择是否
    [checkBtn setSelected:YES];
    for (NSMutableDictionary *goodsDic in self.localCartGoodsArray[section][@"goodsArray"]) {
        if ([goodsDic[@"isCheck"] integerValue] == 1) {
//            [checkBtn setSelected:YES];
        }else
        {
            [checkBtn setSelected:NO];
        }
    }
//    NSSet *setSelected = [NSSet setWithArray:self.localCartGoodsArray];
//    NSSet *setAccount = [NSSet setWithArray:self.cartGoodsArray[section][@"goodsInfo"]];
//    if ([setAccount isSubsetOfSet:setSelected]) {
//        [checkBtn setSelected:YES];
//    }else
//    {
//        [checkBtn setSelected:NO];
//    }
    
    [checkBtn setTag:(section+1000)];
    [checkBtn addTarget:self action:@selector(clickCheckBtn:) forControlEvents:UIControlEventTouchUpInside];
    [sectionView addSubview:checkBtn];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(45, 12, 15, 15)];
    [imgView setImage:[UIImage imageNamed:@"order_store"]];
    [sectionView addSubview:imgView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, kScreenWidth-45 , 40)];
//    [nameLabel setText:[NSString stringWithFormat:@"%@  (%@)",_cartArray[section][@"store_name"],_cartArray[section][@"on_sale"]]];
    if ([_localCartGoodsArray[section][@"goodsArray"][0][@"goodsInfo"][@"businessname"] length] == 0) {
        [nameLabel setText:@"分享购自营"];
    }else
    {
        [nameLabel setText:_localCartGoodsArray[section][@"goodsArray"][0][@"goodsInfo"][@"businessname"]];
    }
    [nameLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [sectionView addSubview:nameLabel];
    
    return sectionView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"选择cell");
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.localCartGoodsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.localCartGoodsArray[section][@"goodsArray"] count] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[ShoppingCartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsZero];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell.productImgView setImageWithURL:[NSURL URLWithString:_localCartGoodsArray[indexPath.section][@"goodsArray"][indexPath.row][@"goodsInfo"][@"imgurl"]] placeholderImage:[UIImage imageNamed:@"product_placeholder"]];
    [cell.nameLabel setText:_localCartGoodsArray[indexPath.section][@"goodsArray"][indexPath.row][@"goodsInfo"][@"goodsname"]];
    [cell.priceLabel setText:[NSString stringWithFormat:@"￥%.2f",[_localCartGoodsArray[indexPath.section][@"goodsArray"][indexPath.row][@"goodsInfo"][@"onprice"] floatValue]]];
    [cell.numLabel setText:_localCartGoodsArray[indexPath.section][@"goodsArray"][indexPath.row][@"goodsNum"]];
    if ([_localCartGoodsArray[indexPath.section][@"goodsArray"][indexPath.row][@"goodsNum"] integerValue] == 1) {
        [cell.minusButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [cell.minusButton setUserInteractionEnabled:NO];
    }else
    {
        [cell.minusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cell.minusButton setUserInteractionEnabled:YES];
    }

    //购物车勾选状态
    if ([_localCartGoodsArray[indexPath.section][@"goodsArray"][indexPath.row][@"isCheck"] integerValue] == 1) {
        [cell.checkButton setSelected:YES];
        //        [cell.checkButton setImage:[UIImage imageNamed:@"check_select"] forState:UIControlStateNormal];
    }else
    {
        [cell.checkButton setSelected:NO];
        //        [cell.checkButton setImage:[UIImage imageNamed:@"check_normal"] forState:UIControlStateNormal];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        for (int i = 0; i<[_localCartGoodsArray count]; i++) {
            if (i == indexPath.section) {
                [_localCartGoodsArray[i][@"goodsArray"] removeObjectAtIndex:indexPath.row];
            }
            if ([_localCartGoodsArray[i][@"goodsArray"] count] == 0) {
                [_localCartGoodsArray removeObjectAtIndex:i];
            }
        }
    }
    [_localCartDic setValue:_localCartGoodsArray forKey:@"data"];
    [ReadWriteSandbox writePropertyFile:_localCartDic FilePath:ShopCart_File_Path];
    
    if ([_localCartGoodsArray count]>0) {
        [_emptyImageView setHidden:YES];
        [_bottomView setHidden:NO];
    }else{
        [_emptyImageView setHidden:NO];
        [_bottomView setHidden:YES];
    }
    
    [_shopCartTableView reloadData];
}

#pragma mark - UIButton Action
- (void)clickCheckBtn:(UIButton *)sender
{
    NSLog(@"选择店铺全选");
    sender.selected = !sender.selected;
    NSLog(@"%d",sender.selected);
    
    NSLog(@"%@",self.localCartDic);
    for (int i = 0; i<[_localCartGoodsArray[sender.tag-1000][@"goodsArray"] count]; i++) {
        NSMutableDictionary *goodsDic = _localCartGoodsArray[sender.tag-1000][@"goodsArray"][i];
        [goodsDic setValue:[NSString stringWithFormat:@"%d",sender.selected] forKey:@"isCheck"];
        [_localCartGoodsArray[sender.tag-1000][@"goodsArray"] replaceObjectAtIndex:i withObject:goodsDic];
    }
    [_localCartDic setValue:_localCartGoodsArray forKey:@"data"];
    [ReadWriteSandbox writePropertyFile:_localCartDic FilePath:ShopCart_File_Path];
    
    [self getLocalShoppingCart];
}

- (void)clickCheckAllBtn:(UIButton *)sender
{
    NSLog(@"全选");
    sender.selected = !sender.selected;
    NSLog(@"%d",sender.selected);
    
    for (int i = 0; i< [_localCartGoodsArray count]; i++) {
        for (int j = 0; j<[_localCartGoodsArray[i][@"goodsArray"] count]; j++) {
            NSMutableDictionary *goodsDic = _localCartGoodsArray[i][@"goodsArray"][j];
            [goodsDic setValue:[NSString stringWithFormat:@"%d",sender.selected] forKey:@"isCheck"];
            [_localCartGoodsArray[i][@"goodsArray"] replaceObjectAtIndex:j withObject:goodsDic];
        }
    }
    
    [_localCartDic setValue:_localCartGoodsArray forKey:@"data"];
    [ReadWriteSandbox writePropertyFile:_localCartDic FilePath:ShopCart_File_Path];
    
    [self getLocalShoppingCart];
}

- (void)clickClearShopCart:(UIButton *)sender
{
    NSLog(@"清空购物车所选商品");
    NSLog(@"%@",_localCartGoodsArray);
    for (int i = 0; i<[_localCartGoodsArray count]; i++) {
        for (int j = 0; j<[_localCartGoodsArray[i][@"goodsArray"] count]; j++) {
            if ([_localCartGoodsArray[i][@"goodsArray"][j][@"isCheck"] integerValue] == 1) {
                [_localCartGoodsArray[i][@"goodsArray"] removeObjectAtIndex:j];
                j--;
            }
        }
        if ([_localCartGoodsArray[i][@"goodsArray"] count] == 0) {
            [_localCartGoodsArray removeObjectAtIndex:i];
            i--;
        }
    }
    
    [_localCartDic setValue:_localCartGoodsArray forKey:@"data"];
    [ReadWriteSandbox writePropertyFile:_localCartDic FilePath:ShopCart_File_Path];
    
    if ([_localCartGoodsArray count]>0) {
        [_emptyImageView setHidden:YES];
        [_bottomView setHidden:NO];
    }else{
        [_emptyImageView setHidden:NO];
        [_bottomView setHidden:YES];
    }
    
    [_shopCartTableView reloadData];
}

- (void)clickSettlementBtn:(UIButton *)sender
{
    NSLog(@"结算……");
    NSMutableArray *cartArray = [NSMutableArray arrayWithArray:_localCartGoodsArray];
    for (int i = 0; i<[cartArray count]; i++) {
        NSMutableArray *goodSArray = [NSMutableArray arrayWithArray:cartArray[i][@"goodsArray"]];
        for (int j = 0; j<[goodSArray count]; j++) {
            if ([goodSArray[j][@"isCheck"] integerValue] == 0) {
                [goodSArray removeObjectAtIndex:j];
                j--;
            }
        }
        if ([goodSArray count] == 0) {
            [cartArray removeObjectAtIndex:i];
        }else
        {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:cartArray[i]];
            [dic setValue:goodSArray forKey:@"goodsArray"];
            [cartArray replaceObjectAtIndex:i withObject:dic];
        }
    }
    
    if ([cartArray count] == 0) {
        [self showHint:@"请选择商品" yOffset:-250];
        return;
    }
    FillOrderViewController *writeOrderVC = [[FillOrderViewController alloc] init];
    writeOrderVC.orderType = @"1";
    writeOrderVC.goodsArray = cartArray;
    writeOrderVC.isShopCartOrder = YES;
    [self.navigationController pushViewController:writeOrderVC animated:YES];
}

#pragma mark - ShoppingCartCellDelegate
- (void)shoppingCartMinusBtn:(ShoppingCartCell *)cell
{
    NSLog(@"商品数量减");
    NSIndexPath *indexPath = [_shopCartTableView indexPathForCell:cell];
    NSLog(@"indexPath is = %lu",indexPath.row);
    [cell.numLabel setText:[NSString stringWithFormat:@"%lu",[cell.numLabel.text integerValue]-1]];
    
    if ([cell.numLabel.text integerValue]<=1) {
        [cell.minusButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [cell.minusButton setUserInteractionEnabled:NO];
    }else
    {
        [cell.minusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cell.minusButton setUserInteractionEnabled:YES];
    }
    NSLog(@"%@",_localCartGoodsArray);
    NSMutableDictionary *goodsDic = _localCartGoodsArray[indexPath.section][@"goodsArray"][indexPath.row];
    [goodsDic setValue:cell.numLabel.text forKey:@"goodsNum"];
    [_localCartGoodsArray[indexPath.section][@"goodsArray"] replaceObjectAtIndex:indexPath.row withObject:goodsDic];
    [_localCartDic setValue:_localCartGoodsArray forKey:@"data"];
    [ReadWriteSandbox writePropertyFile:_localCartDic FilePath:ShopCart_File_Path];
    
    [self getLocalShoppingCart];
}

- (void)shoppingCartPlusBtn:(ShoppingCartCell *)cell
{
    NSLog(@"商品数量加");
    NSIndexPath *indexPath = [_shopCartTableView indexPathForCell:cell];
    NSLog(@"indexPath is = %lu",indexPath.row);
    
    [cell.numLabel setText:[NSString stringWithFormat:@"%lu",[cell.numLabel.text integerValue]+1]];
    
    if ([cell.numLabel.text integerValue] >1) {
        [cell.minusButton setUserInteractionEnabled:YES];
        [cell.minusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else
    {
        [cell.minusButton setUserInteractionEnabled:NO];
        [cell.minusButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    
    NSMutableDictionary *goodsDic = _localCartGoodsArray[indexPath.section][@"goodsArray"][indexPath.row];
    [goodsDic setValue:cell.numLabel.text forKey:@"goodsNum"];
    [_localCartGoodsArray[indexPath.section][@"goodsArray"] replaceObjectAtIndex:indexPath.row withObject:goodsDic];
    [_localCartDic setValue:_localCartGoodsArray forKey:@"data"];
    [ReadWriteSandbox writePropertyFile:_localCartDic FilePath:ShopCart_File_Path];
    
    [self getLocalShoppingCart];
}

- (void)shoppingCartCheckBtn:(ShoppingCartCell *)cell
{
    NSIndexPath *indexPath = [_shopCartTableView indexPathForCell:cell];
    NSLog(@"indexPath is = %lu",indexPath.row);
    
    NSLog(@"%@",self.localCartDic);
    NSMutableDictionary *goodsDic = _localCartGoodsArray[indexPath.section][@"goodsArray"][indexPath.row];
    [goodsDic setValue:[NSString stringWithFormat:@"%ld",1- [_localCartGoodsArray[indexPath.section][@"goodsArray"][indexPath.row][@"isCheck"] integerValue]] forKey:@"isCheck"];
    [_localCartGoodsArray[indexPath.section][@"goodsArray"] replaceObjectAtIndex:indexPath.row withObject:goodsDic];
    [_localCartDic setValue:_localCartGoodsArray forKey:@"data"];
    [ReadWriteSandbox writePropertyFile:_localCartDic FilePath:ShopCart_File_Path];
    
    [self getLocalShoppingCart];
}

#pragma mark - data storage 数据存储
- (void)getLocalShoppingCart
{
    self.localCartGoodsArray = [NSMutableArray array];
    if ([ReadWriteSandbox propertyFileExists:ShopCart_File_Path]) {
        self.localCartDic = [NSMutableDictionary dictionaryWithDictionary:[ReadWriteSandbox readPropertyFile:ShopCart_File_Path]];
        NSArray *cartArray = [ReadWriteSandbox readPropertyFile:ShopCart_File_Path][@"data"];
        for (int i = 0; i<[cartArray count]; i++) {
            if ([cartArray[i][@"userToken"] isEqual:[UserModel shareUserModel].userToken]) {
                [self.localCartGoodsArray addObject:cartArray[i]];
            }
        }
    }
    
    if ([_localCartGoodsArray count]>0) {
        [_emptyImageView setHidden:YES];
        [_bottomView setHidden:NO];
    }else{
        [_emptyImageView setHidden:NO];
        [_bottomView setHidden:YES];
    }
    
    [_shopCartTableView reloadData];
    
    [self decideAllCheck];
    [self calculateShoppingCartPrice];
}

//判断是否全选
- (void)decideAllCheck
{
    [_checkAllButton setSelected:YES];
    for (int i = 0; i<[self.localCartGoodsArray count]; i++) {
        for (NSMutableDictionary *goodsDic in self.localCartGoodsArray[i][@"goodsArray"]) {
            if ([goodsDic[@"isCheck"] integerValue] == 1) {
//                [_checkAllButton setSelected:YES];
            }else
            {
                [_checkAllButton setSelected:NO];
            }
        }
    }

}

//计算选中商品总价
- (void)calculateShoppingCartPrice
{
    float money = 0;
    for (int i = 0; i<[_localCartGoodsArray count]; i++) {
        for (int j = 0; j<[_localCartGoodsArray[i][@"goodsArray"] count]; j++) {
            if ([_localCartGoodsArray[i][@"goodsArray"][j][@"isCheck"] integerValue] == 1) {
                money += [_localCartGoodsArray[i][@"goodsArray"][j][@"goodsInfo"][@"onprice"] floatValue] *[_localCartGoodsArray[i][@"goodsArray"][j][@"goodsNum"] integerValue];
            }
        }
    }
//    [_totalPriceLabel setText:[NSString stringWithFormat:@"合计：￥%.2f",money]];
    NSString *totalStr = [NSString stringWithFormat:@"合计：￥%.2f",money];
    NSMutableAttributedString *totalAttStr = [[NSMutableAttributedString alloc] initWithString:totalStr];
    [totalAttStr addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0xff5f3b, 1) range:NSMakeRange(3, totalStr.length - 3)];
    _totalPriceLabel.attributedText = totalAttStr;
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
