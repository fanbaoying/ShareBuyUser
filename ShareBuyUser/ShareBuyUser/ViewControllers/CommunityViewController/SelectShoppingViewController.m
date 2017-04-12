//
//  SelectShoppingViewController.m
//  ShareBuyUser
//
//  Created by 刘兵 on 16/8/9.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "SelectShoppingViewController.h"
#import "SelectShoppingCell.h"
//#import "WriteOrderViewController.h"
#import "FillOrderViewController.h"

@interface SelectShoppingViewController ()<UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate,ShoppingCartCellDelegate, UITextFieldDelegate>
{
    UILabel *numberLabel;
    UILabel *totalLabel;
    
    NSInteger currentPage;
    NSMutableDictionary *postGoodsDic;
    float money;
    int num ;

}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UITextField *topTextField;

@property (nonatomic, strong) NSMutableArray *resultArray;
@property (nonatomic, strong) NSMutableArray *goodsArray;

@end

@implementation SelectShoppingViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    postGoodsDic = [NSMutableDictionary dictionary];
    self.resultArray = [NSMutableArray array];
    self.goodsArray = [NSMutableArray array];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(50, 5, 100, 30)];
    searchBar.delegate = self;
    searchBar.placeholder = @"请输入搜索关键字";
    searchBar.returnKeyType = UIReturnKeySearch;
//    searchBar.showsCancelButton = NO;
    
    self.navigationItem.titleView = searchBar;
    
    [self.view addSubview:self.tableView];
    [self createFooter];
    
    currentPage = 0;
    [postGoodsDic setValue:[NSString stringWithFormat:@"%lu",currentPage+1] forKey:@"pageIndex"];
    [self getGoodsListRequestWithDict:postGoodsDic WithRefresh:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Get Method

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHight - 45) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableView setTableHeaderView:self.headerView];
        
        [_tableView addLegendFooterWithRefreshingBlock:^{
            NSLog(@"");
            currentPage++;
            [postGoodsDic setValue:[NSString stringWithFormat:@"%lu",currentPage+1] forKey:@"pageIndex"];
            [self getGoodsListRequestWithDict:postGoodsDic WithRefresh:NO];
        }];
        
    }
    return _tableView;
}

#pragma mark - Action

- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
            [view setBackgroundColor:[UIColor whiteColor]];
            
            NSArray *titleArr = @[@"价格",@"销量",@"人气"];
            for (int i = 0; i < 3; i++) {
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10+i*((kScreenWidth - 60)/3+20), 10, (kScreenWidth - 60)/3, 30)];
                [btn setTitle:titleArr[i] forState:UIControlStateNormal];
                [btn setTitleColor:UIColorFromHex(0x999999, 1) forState:UIControlStateNormal];
                btn.backgroundColor = UIColorFromHex(0xf1f1f1, 1);
                btn.titleLabel.font = UIFontPingFangLight(14);
                btn.layer.cornerRadius = 5;
                btn.layer.masksToBounds = YES;
                btn.layer.borderWidth = 1;
                btn.layer.borderColor = UIColorFromHex(0xbbbbbb, 1).CGColor;
                [btn setImage:[UIImage imageNamed:@"selectShopping_downArrow"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"selectShopping_upArrow"] forState:UIControlStateSelected];
                [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -CGRectGetWidth(btn.frame)/2, 0, 0)];
                [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -CGRectGetWidth(btn.frame))];
                btn.tag = 100+i;
                [btn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:btn];
            }
            
            
            view;
        });
    }
    return _headerView;
}

- (void)createFooter {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 45 - 64, kScreenWidth, 45)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    line.backgroundColor = UIColorFromHex(0xcccccc, 1);
    [view addSubview:line];
    
    numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 25)];
    numberLabel.font = UIFontPingFangMedium(14);
    NSString *numStr = @"共0件商品";
    NSString *totalStr = @"合计：¥0.00";
    NSMutableAttributedString *numAttStr = [[NSMutableAttributedString alloc] initWithString:numStr];
    NSRange range = [numStr rangeOfString:@"件"];
    [numAttStr addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0xff5f3b, 1) range:NSMakeRange(1, range.location - 1)];
    numberLabel.attributedText = numAttStr;
    [view addSubview:numberLabel];
    
    totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(numberLabel.frame), CGRectGetMinY(numberLabel.frame), kScreenWidth - CGRectGetMaxX(numberLabel.frame) - 90, CGRectGetHeight(numberLabel.frame))];
    totalLabel.textAlignment = NSTextAlignmentRight;
    NSMutableAttributedString *totalAttStr = [[NSMutableAttributedString alloc] initWithString:totalStr];
    [totalAttStr addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0xff5f3b, 1) range:NSMakeRange(3, totalStr.length - 3)];
    totalLabel.attributedText = totalAttStr;
    totalLabel.font = UIFontPingFangMedium(14);
    [view addSubview:totalLabel];
    
    UIButton *bottomBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 85, 0, 85, 45)];
    bottomBtn.backgroundColor = UIColorFromHex(0xff5f3b, 1);
    [bottomBtn setTitle:@"我选完啦" forState:UIControlStateNormal];
    bottomBtn.titleLabel.font = UIFontPingFangMedium(15);
    [bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottomBtn addTarget:self action:@selector(bottomBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:bottomBtn];
}

- (void)bottomBtnClick {
    NSLog(@"我选完啦");
//    WriteOrderViewController *vc = [[WriteOrderViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    if (![UserModel ifLogin]) {
        [self presentViewController:[[BaseNavController alloc] initWithRootViewController:[LoginViewController new]] animated:YES completion:^{
        }];
        return;
    }
    
    if ([_goodsArray count] == 0) {
        [self showHint:@"请选择商品" yOffset:-250];
        return;
    }
    FillOrderViewController *fillOrderVC = [[FillOrderViewController alloc] init];
    fillOrderVC.goodsArray = _goodsArray;
    fillOrderVC.shareID = _shareID;
    fillOrderVC.orderType = @"1";
    fillOrderVC.isShopCartOrder = NO;
    [self.navigationController pushViewController:fillOrderVC animated:YES];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_resultArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell";
    SelectShoppingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[SelectShoppingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.delegate = self;
    
    [cell.productImgView setImageWithURL:[NSURL URLWithString:_resultArray[indexPath.section][@"imgurl"]] placeholderImage:[UIImage imageNamed:@"product_placeholder"]];
    [cell.nameLabel setText:_resultArray[indexPath.section][@"goodsname"]];
    [cell.priceLabel setText:[NSString stringWithFormat:@"￥%.2f",[_resultArray[indexPath.section][@"onprice"] floatValue]]];
    [cell.numLabel setText:@"0"];

    for (int i = 0; i<[_goodsArray count]; i++) {
        for (int j = 0; j<[_goodsArray[i][@"goodsArray"] count]; j++) {
            if ([_resultArray[indexPath.section][@"goodsid"] isEqual:_goodsArray[i][@"goodsArray"][j][@"goodsInfo"][@"goodsid"]]) {
                [cell.numLabel setText:_goodsArray[i][@"goodsArray"][j][@"goodsNum"]];
            }
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
//    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    NSLog(@"%@", searchBar.text);
    
    [postGoodsDic setValue:searchBar.text forKey:@"goodsname"];
    currentPage = 0;
    [postGoodsDic setValue:[NSString stringWithFormat:@"%lu",currentPage+1] forKey:@"pageIndex"];
    [self getGoodsListRequestWithDict:postGoodsDic WithRefresh:YES];
}

//- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
//    [searchBar resignFirstResponder];
//    [searchBar setShowsCancelButton:NO animated:YES];
//}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - ShoppingCartCellDelegate
- (void)shoppingCartMinusBtn:(SelectShoppingCell *)cell
{
    NSLog(@"商品数量减");
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    NSLog(@"indexPath is = %lu",indexPath.row);

    if ([cell.numLabel.text integerValue] != 0) {
        [cell.numLabel setText:[NSString stringWithFormat:@"%lu",[cell.numLabel.text integerValue]-1]];
    }
    
    if ([cell.numLabel.text integerValue] == 0) {
        [cell.minusButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [cell.minusButton setUserInteractionEnabled:NO];
    }
    else
    {
        [cell.minusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cell.minusButton setUserInteractionEnabled:YES];
    }
    
    BOOL isHaveGoodID = NO;
    for (int i = 0; i<[_goodsArray count]; i++) {
        for (int j = 0; j<[_goodsArray[i][@"goodsArray"] count]; j++) {
            if ([_resultArray[indexPath.section][@"goodsid"] isEqual:_goodsArray[i][@"goodsArray"][j][@"goodsInfo"][@"goodsid"]]) {
                isHaveGoodID = YES;
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:_goodsArray[i][@"goodsArray"][j]];
                [dict setValue:cell.numLabel.text forKey:@"goodsNum"];
                [_goodsArray[i][@"goodsArray"] replaceObjectAtIndex:j withObject:dict];
            }
        }
    }
    
    for (int i = 0; i<[_goodsArray count]; i++) {
        for (int j = 0; j<[_goodsArray[i][@"goodsArray"] count]; j++) {
            if ([_goodsArray[i][@"goodsArray"][j][@"goodsNum"] integerValue] == 0) {
                [_goodsArray[i][@"goodsArray"] removeObjectAtIndex:j];
            }
        }
        if ([_goodsArray[i][@"goodsArray"] count] == 0) {
            [_goodsArray removeObjectAtIndex:i];
        }
    }
    
    [self calculatePrice];
}

- (void)shoppingCartPlusBtn:(SelectShoppingCell *)cell
{
    NSLog(@"商品数量加");
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    NSLog(@"indexPath is = %lu",indexPath.row);
    
    [cell.numLabel setText:[NSString stringWithFormat:@"%lu",[cell.numLabel.text integerValue]+1]];
    
    if ([cell.numLabel.text integerValue] > 0) {
        [cell.minusButton setUserInteractionEnabled:YES];
        [cell.minusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    else
    {
        [cell.minusButton setUserInteractionEnabled:NO];
        [cell.minusButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    
    BOOL isHaveGoodID = NO;
    for (int i = 0; i<[_goodsArray count]; i++) {
        if ([_resultArray[indexPath.section][@"businessid"] isEqual:_goodsArray[i][@"businessid"]]) {
            for (int j = 0; j<[_goodsArray[i][@"goodsArray"] count]; j++) {
                if ([_resultArray[indexPath.section][@"goodsid"] isEqual:_goodsArray[i][@"goodsArray"][j][@"goodsInfo"][@"goodsid"]]) {
                    isHaveGoodID = YES;
                    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:_goodsArray[i][@"goodsArray"][j]];
                    [dict setValue:cell.numLabel.text forKey:@"goodsNum"];
                    [_goodsArray[i][@"goodsArray"] replaceObjectAtIndex:j withObject:dict];
                }
            }
            
            if (!isHaveGoodID) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setValue:_resultArray[indexPath.section] forKey:@"goodsInfo"];
                [dict setValue:@"1" forKey:@"goodsNum"];
                [_goodsArray[i][@"goodsArray"] addObject:dict];
                isHaveGoodID = YES;
            }
        }
    }
    
    if (!isHaveGoodID) {
        NSMutableArray *goodArr = [NSMutableArray array];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];

        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:_resultArray[indexPath.section] forKey:@"goodsInfo"];
        [dict setValue:@"1" forKey:@"goodsNum"];
        [goodArr addObject:dict];
        
        [dic setValue:goodArr forKey:@"goodsArray"];
        [dic setValue:_resultArray[indexPath.section][@"businessid"] forKey:@"businessid"];
        
        [_goodsArray addObject:dic];
    }
    
    [self calculatePrice];
}


#pragma mark - UIButton Action
- (void)topBtnClick:(UIButton *)button
{
    [_topTextField resignFirstResponder];

    button.selected = !button.selected;
    NSLog(@"%ld", (long)button.tag);
    for (int i = 0; i<3; i++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:100+i];
        [button setBackgroundColor:UIColorFromHex(0xf1f1f1, 1)];
    }
    [button setBackgroundColor:kMainColor];
    
    switch (button.tag) {
        case 100:
            NSLog(@"价格");
            if (button.selected) {
                [postGoodsDic setValue:@"1" forKey:@"sort"];
            }else
            {
                [postGoodsDic setValue:@"2" forKey:@"sort"];
            }
            break;
        case 101:
            NSLog(@"销量");
            if (button.selected) {
                [postGoodsDic setValue:@"3" forKey:@"sort"];
            }else
            {
                [postGoodsDic setValue:@"4" forKey:@"sort"];
            }
            break;
        case 102:
            NSLog(@"人气");
            if (button.selected) {
                [postGoodsDic setValue:@"5" forKey:@"sort"];
            }else
            {
                [postGoodsDic setValue:@"6" forKey:@"sort"];
            }
            break;
            
        default:
            break;
    }
    
    currentPage = 0;
    [postGoodsDic setValue:[NSString stringWithFormat:@"%lu",currentPage+1] forKey:@"pageIndex"];
    [self getGoodsListRequestWithDict:postGoodsDic WithRefresh:YES];
}

//计算钱数
- (void)calculatePrice
{
    money = 0;
    num = 0;
    for (int i = 0; i<[_goodsArray count]; i++) {
        for (int j = 0; j<[_goodsArray[i][@"goodsArray"] count]; j++) {
            money += [_goodsArray[i][@"goodsArray"][j][@"goodsInfo"][@"onprice"] floatValue] *[_goodsArray[i][@"goodsArray"][j][@"goodsNum"] integerValue];
            num += [_goodsArray[i][@"goodsArray"][j][@"goodsNum"] integerValue];
        }
    }
    
    NSString *numStr = [NSString stringWithFormat:@"共%d件商品",num];
    NSMutableAttributedString *numAttStr = [[NSMutableAttributedString alloc] initWithString:numStr];
    NSRange range = [numStr rangeOfString:@"件"];
    [numAttStr addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0xff5f3b, 1) range:NSMakeRange(1, range.location - 1)];
    numberLabel.attributedText = numAttStr;
    
    NSString *totalStr = [NSString stringWithFormat:@"合计：¥%.2f",money];
    NSMutableAttributedString *totalAttStr = [[NSMutableAttributedString alloc] initWithString:totalStr];
    [totalAttStr addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0xff5f3b, 1) range:NSMakeRange(3, totalStr.length - 3)];
    totalLabel.attributedText = totalAttStr;
}

#pragma mark - Net Working
//商品搜索
- (void)getGoodsListRequestWithDict:(NSDictionary *)dict WithRefresh:(BOOL)isRefresh
{
    if (isRefresh) {
        [_resultArray removeAllObjects];
    }
    [self showHudInView:self.view hint:nil];
    [DDPBLL requestWithURL:DEF_URL_GetGoodsList  Dict:dict result:^(NSDictionary *responseDict) {
        [self hideHud];
        NSLog(@"%@",responseDict);
        if (responseDict == nil) {
            return ;
        }
        if ([[responseDict objectForKey:@"status"] integerValue] == 0) {
            if ([responseDict[@"data"] count] != 0) {
                [_tableView.legendFooter endRefreshing];
                [_resultArray addObjectsFromArray:responseDict[@"data"]];
            }else
            {
                // legendFooter置为"没有更多内容了"状态
                [_tableView.legendFooter noticeNoMoreData];
            }
            [_tableView reloadData];
        }
        else{
            [self showHint:responseDict[@"msg"]];
        }
    }];
}

//查询订单详情


@end
