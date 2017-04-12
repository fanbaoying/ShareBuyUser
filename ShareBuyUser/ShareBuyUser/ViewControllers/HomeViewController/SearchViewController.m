//
//  SearchViewController.m
//  ShareBuyUser
//
//  Created by soldier on 16/8/25.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "SearchViewController.h"
#import "GoodsCell.h"
#import "BaseWebViewController.h"
#import "StoreDetailViewController.h"

@interface SearchViewController () <UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSInteger currentPage;
    NSMutableDictionary *postGoodsDic;
    NSMutableDictionary *postStoreDic;
    NSArray *typeArray;
    
    UIView *pickerTopView;
    UIPickerView *pickerView;
    NSInteger selectRow;
}

@property (nonatomic, strong) UISearchBar *mySearchBar;
@property (nonatomic, strong) UIBarButtonItem *typeBarBtnItem;
@property (nonatomic, strong) UITableView *resultTableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIButton *typeButton;

@property (nonatomic, assign) BOOL isGoodsType;             //搜索类型（商品搜索Yes,店铺搜索No）
@property (nonatomic, strong) NSMutableArray *resultArray;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    typeArray = @[@"商品搜索",@"商铺搜索"];
    postGoodsDic = [NSMutableDictionary dictionary];
    postStoreDic = [NSMutableDictionary dictionary];
    _isGoodsType = YES;
    self.resultArray = [NSMutableArray array];
    
    [self.navigationItem setTitleView:self.mySearchBar];
    self.navigationItem.rightBarButtonItem = self.typeBarBtnItem;
    [self.view addSubview:self.resultTableView];
    
    [self createPicker];
}

- (void)confirmBtnClick {
    pickerTopView.hidden = YES;
    pickerView.hidden = YES;
    
    [_typeButton setTitle:typeArray[selectRow] forState:UIControlStateNormal];
    
    _isGoodsType = !selectRow;
    
    if (_isGoodsType) {
        [_resultTableView setTableHeaderView:self.headerView];

        [postGoodsDic setValue:_mySearchBar.text forKey:@"goodsname"];
        currentPage = 0;
        [postGoodsDic setValue:[NSString stringWithFormat:@"%lu",currentPage+1] forKey:@"pageIndex"];
        [self getGoodsListRequestWithDict:postGoodsDic WithRefresh:YES];
        
    }else
    {
        [_resultTableView setTableHeaderView:[UIView new]];

        [postStoreDic setValue:_mySearchBar.text forKey:@"businessname"];
        currentPage = 0;
        [postStoreDic setValue:[NSString stringWithFormat:@"%lu",currentPage+1] forKey:@"pageIndex"];
        [self findBusinessListRequestWithDict:postStoreDic WithRefresh:YES];
    }
}

- (void)cancelBtnClick {
    pickerTopView.hidden = YES;
    pickerView.hidden = YES;
}


#pragma mark - Get Method
- (UISearchBar *)mySearchBar
{
    if (!_mySearchBar) {
        _mySearchBar = ({
            UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth -160, 44)];
            [searchBar setBackgroundColor:[UIColor clearColor]];
            [searchBar setPlaceholder:@"关键词搜索"];
            searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
            searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
            searchBar.keyboardType =  UIKeyboardTypeDefault;
            
            [[[[searchBar.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
            [searchBar setBackgroundColor:[UIColor clearColor]];
            
            [searchBar setShowsCancelButton:NO animated:YES];
            [searchBar setDelegate:self];
            
            searchBar;
        });
    }
    return _mySearchBar;
}

- (UIBarButtonItem *)typeBarBtnItem
{
    if (!_typeBarBtnItem) {
        _typeBarBtnItem = ({
            _typeButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 80, 5, 80, 30)];
            [_typeButton setTitle:typeArray[0] forState:UIControlStateNormal];
            [_typeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _typeButton.titleLabel.font = UIFontPingFangMedium(14);
            [_typeButton addTarget:self action:@selector(searchTypeClick) forControlEvents:UIControlEventTouchUpInside];
            [_typeButton setImage:[UIImage imageNamed:@"selectShopping_downArrow_white"] forState:UIControlStateNormal];
            [_typeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -110)];
            [_typeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
            
            UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:_typeButton];
            barBtnItem;
        });
    }
    return _typeBarBtnItem;
}

- (UITableView *)resultTableView
{
    if (!_resultTableView) {
        _resultTableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHight) style:UITableViewStylePlain];
            [tableView setDataSource:self];
            [tableView setDelegate:self];
            [tableView setBackgroundColor:[UIColor clearColor]];
            [tableView setTableHeaderView:self.headerView];
            [tableView setTableFooterView:[UIView new]];
            [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            
            [tableView addLegendFooterWithRefreshingBlock:^{
                currentPage++;
                
                if (_isGoodsType) {
                    [postGoodsDic setValue:[NSString stringWithFormat:@"%lu",currentPage+1] forKey:@"pageIndex"];
                    [self getGoodsListRequestWithDict:postGoodsDic WithRefresh:NO];
                }else
                {
                    [postStoreDic setValue:[NSString stringWithFormat:@"%lu",currentPage+1] forKey:@"pageIndex"];
                    [self findBusinessListRequestWithDict:postStoreDic WithRefresh:NO];
                }

            }];
            
            tableView;
        });
    }
    return _resultTableView;
}

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
//                [btn setImage:[UIImage imageNamed:@"selectShopping_upArrow"] forState:UIControlStateSelected];
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


#pragma mark - UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"取消搜索,返回上一页");
    [_mySearchBar resignFirstResponder];
    [_mySearchBar setShowsCancelButton:NO animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_mySearchBar resignFirstResponder];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [_mySearchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

//- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
//{
//    NSLog(@"1111111");
//    [searchBar setShowsCancelButton:NO animated:YES];
//    return YES;
//}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    NSLog(@"22222222222");
    [_mySearchBar resignFirstResponder];
    
    if (_isGoodsType) {
        [postGoodsDic setValue:_mySearchBar.text forKey:@"goodsname"];
        currentPage = 0;
        [postGoodsDic setValue:[NSString stringWithFormat:@"%lu",currentPage+1] forKey:@"pageIndex"];
        [self getGoodsListRequestWithDict:postGoodsDic WithRefresh:YES];
    }else
    {
        [postStoreDic setValue:_mySearchBar.text forKey:@"businessname"];
        currentPage = 0;
        [postStoreDic setValue:[NSString stringWithFormat:@"%lu",currentPage+1] forKey:@"pageIndex"];
        [self findBusinessListRequestWithDict:postStoreDic WithRefresh:YES];
    }
    
    [searchBar setShowsCancelButton:NO animated:YES];
}

//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
//{
//    [_mySearchBar setShowsCancelButton:NO animated:YES];
//}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"选择cell");
    if (_isGoodsType) {
        BaseWebViewController *baseWebVC = [[BaseWebViewController alloc] init];
        baseWebVC.webUrlStr = [NSString stringWithFormat:@"%@/app/goodsInfo/index?goodsid=%@&&state=1",BASE_URL,_resultArray[indexPath.row][@"goodsid"]];
        baseWebVC.goodsId = _resultArray[indexPath.row][@"goodsid"];
        [self.navigationController pushViewController:baseWebVC animated:YES];
    }else
    {
        StoreDetailViewController *storeDetailVC = [[StoreDetailViewController alloc] init];
        [storeDetailVC setTitle:_resultArray[indexPath.row][@"businessname"]];
        storeDetailVC.imgUrlStr = _resultArray[indexPath.row][@"logo"];
        storeDetailVC.storeID = _resultArray[indexPath.row][@"businessid"];
        [self.navigationController pushViewController:storeDetailVC animated:YES];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_resultArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    GoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[GoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsZero];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (_isGoodsType)
    {
        [cell.imgView setImageWithURL:[NSURL URLWithString:_resultArray[indexPath.row][@"imgurl"]] placeholderImage:[UIImage imageNamed:@"product_placeholder"]];
        [cell.nameLabel setText:_resultArray[indexPath.row][@"goodsname"]];
        [cell.priceLabel setTextColor:kMainColor];
        [cell.priceLabel setFont:UIFontPingFangMedium(15.0f)];
        [cell.priceLabel setText:[NSString stringWithFormat:@"￥%.2f",[_resultArray[indexPath.row][@"onprice"]floatValue]]];
    }
    else
    {
        [cell.imgView setImageWithURL:[NSURL URLWithString:_resultArray[indexPath.row][@"logo"]] placeholderImage:[UIImage imageNamed:@"product_placeholder"]];
        [cell.nameLabel setText:_resultArray[indexPath.row][@"businessname"]];
        [cell.priceLabel setTextColor:UIColorFromHex(0x696969, 1)];
        [cell.priceLabel setFont:UIFontPingFangMedium(14.0f)];
        [cell.priceLabel setText:[NSString stringWithFormat:@"%@",_resultArray[indexPath.row][@"address"]]];
    }
    
    return cell;
}


#pragma mark - UIButton Action
- (void)topBtnClick:(UIButton *)button
{
    [_mySearchBar resignFirstResponder];
    button.selected = !button.selected;
    NSLog(@"%ld", (long)button.tag);
    for (int i = 0; i<3; i++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:100+i];
        [button setBackgroundColor:UIColorFromHex(0xf1f1f1, 1)];
        [button setTitleColor:UIColorFromHex(0x999999, 1) forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"selectShopping_downArrow"] forState:UIControlStateNormal];
    }
    [button setBackgroundColor:kMainColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if (button.selected) {
        [button setImage:[UIImage imageNamed:@"selectShopping_upArrow_white"] forState:UIControlStateNormal];
    }else
    {
        [button setImage:[UIImage imageNamed:@"selectShopping_downArrow_white"] forState:UIControlStateNormal];
    }
    
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

- (void)searchTypeClick
{
    [_mySearchBar resignFirstResponder];

    NSLog(@"选择搜索类型");
    pickerTopView.hidden = NO;
    pickerView.hidden = NO;
}

#pragma mark - UIPickerViewDelegate, UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return typeArray.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return typeArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectRow = row;
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
                [_resultTableView.legendFooter endRefreshing];
                [_resultArray addObjectsFromArray:responseDict[@"data"]];
            }else
            {
                // legendFooter置为"没有更多内容了"状态
                [_resultTableView.legendFooter noticeNoMoreData];
            }
            [_resultTableView reloadData];
        }
        else{
            [self showHint:responseDict[@"msg"]];
        }
    }];
}

//店铺搜索  
- (void)findBusinessListRequestWithDict:(NSDictionary *)dict WithRefresh:(BOOL)isRefresh
{
    if (isRefresh) {
        [_resultArray removeAllObjects];
    }
    [self showHudInView:self.view hint:nil];
    [DDPBLL requestWithURL:DEF_URL_FindBusinessList  Dict:dict result:^(NSDictionary *responseDict) {
        [self hideHud];
        NSLog(@"%@",responseDict);
        if (responseDict == nil) {
            return ;
        }
        if ([[responseDict objectForKey:@"status"] integerValue] == 0) {
            if ([responseDict[@"data"] count] != 0) {
                [_resultTableView.legendFooter endRefreshing];
                [_resultArray addObjectsFromArray:responseDict[@"data"]];
            }else
            {
                // legendFooter置为"没有更多内容了"状态
                [_resultTableView.legendFooter noticeNoMoreData];
            }
            [_resultTableView reloadData];
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
