//
//  StoreCategoryViewController.m
//  ShareBuyUser
//
//  Created by soldier on 16/8/10.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "StoreCategoryViewController.h"
#import "GoodsCell.h"
#import "BaseWebViewController.h"

@interface StoreCategoryViewController () <UITableViewDelegate,UITableViewDataSource>
{
    NSInteger currentPage;
}

@property (nonatomic, strong) UITableView *categoryTableView;
@property (nonatomic, strong) NSMutableArray *goodsArray;

@property (nonatomic, strong) NSMutableArray *localCartGoodsArray;
@property (nonatomic, strong) NSMutableDictionary *localCartDic;            //本地购物车数据

@end

@implementation StoreCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"分类详情"];
    
    self.goodsArray = [NSMutableArray array];
    [self.view addSubview:self.categoryTableView];
    
    currentPage = 0;
    NSDictionary *dic = @{@"pageIndex":[NSString stringWithFormat:@"%ld",currentPage+1],@"businessid":self.storeID,@"categoryid":self.categoryID};
    [self getGoodsListRequestWithDict:dic];
    
//    [self getLocalShoppingCart];
}

- (UITableView *)categoryTableView
{
    if (!_categoryTableView) {
        _categoryTableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHight) style:UITableViewStylePlain];
            [tableView setDelegate:self];
            [tableView setDataSource:self];
            [tableView setBackgroundColor:[UIColor clearColor]];
            [tableView setTableFooterView:[UIView new]];
            [tableView setSeparatorInset:UIEdgeInsetsZero];
            [tableView setLayoutMargins:UIEdgeInsetsZero];
            [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            
            [tableView addLegendFooterWithRefreshingBlock:^{
                currentPage++;
                NSDictionary *dic = @{@"pageIndex":[NSString stringWithFormat:@"%ld",currentPage+1],@"businessid":self.storeID,@"categoryid":self.categoryID};
                [self getGoodsListRequestWithDict:dic];
            }];
            
            tableView;
        });
    }
    return _categoryTableView;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"选择cell");
    
    if (![UserModel ifLogin]) {
        [self presentViewController:[[BaseNavController alloc] initWithRootViewController:[LoginViewController new]] animated:YES completion:^{
        }];
        return;
    }
    
    BaseWebViewController *baseWebVC = [[BaseWebViewController alloc] init];
    baseWebVC.webUrlStr = [NSString stringWithFormat:@"%@/app/goodsInfo/index?goodsid=%@&&state=1",BASE_URL,_goodsArray[indexPath.row][@"goodsid"]];
    baseWebVC.goodsId = _goodsArray[indexPath.row][@"goodsid"];
//    baseWebVC.goodsDic = _goodsArray[indexPath.row];
//    baseWebVC.webUrlStr = [NSString stringWithFormat:@"%@app/goodsInfo/index?goodsid=%@&&state=1",@"http://10.58.160.112:8080/shareApp/",_goodsArray[indexPath.row][@"goodsid"]];
    [self.navigationController pushViewController:baseWebVC animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_goodsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    GoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[GoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.delegate = self;
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsZero];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell.imgView setImageWithURL:[NSURL URLWithString:_goodsArray[indexPath.row][@"imgurl"]] placeholderImage:[UIImage imageNamed:@"product_placeholder"]];
    [cell.nameLabel setText:_goodsArray[indexPath.row][@"goodsname"]];
    [cell.priceLabel setText:[NSString stringWithFormat:@"￥%.2f",[_goodsArray[indexPath.row][@"onprice"] floatValue]]];
    
    return cell;
}

#pragma mark - NetWorking
//根据类别获取商铺的商品列表 
- (void)getGoodsListRequestWithDict:(NSDictionary *)dict
{
    [self showHudInView:self.view hint:nil];
    [DDPBLL requestWithURL:DEF_URL_GetGoodsList  Dict:dict result:^(NSDictionary *responseDict) {
        [self hideHud];
        NSLog(@"%@",responseDict);
        if (responseDict == nil) {
            return ;
        }
        if ([[responseDict objectForKey:@"status"] integerValue] == 0) {
            if ([responseDict[@"data"] count] != 0) {
                [_categoryTableView.legendFooter endRefreshing];
                [self.goodsArray addObjectsFromArray:responseDict[@"data"]];
            }else
            {
                // legendFooter置为"没有更多内容了"状态
                [_categoryTableView.legendFooter noticeNoMoreData];
            }
            [_categoryTableView reloadData];
        }
        else{
            [self showHint:responseDict[@"msg"]];
        }
    }];
}

#pragma mark - GoodsCellDelegate
- (void)numberPlus:(GoodsCell *)cell
{
    NSIndexPath *indexPath = [_categoryTableView indexPathForCell:cell];
    
    //判断本地购物车中，是否有该商品。如有，数量变化；未有，新增商品
    BOOL isHaveGood = NO;
    for (int j = 0; j<[_localCartGoodsArray count]; j++) {
        if ([_goodsArray[indexPath.row][@"goodsid"] isEqual:_localCartGoodsArray[j][@"goodsInfo"][@"goodsid"]]) {
            NSLog(@"存在该商品");
            [_localCartGoodsArray[j] setValue:[NSString stringWithFormat:@"%d",[_localCartGoodsArray[j][@"goodsNum"] intValue]+1] forKey:@"goodsNum"];
            [_localCartGoodsArray[j] setValue:@"1" forKey:@"isCheck"];
            isHaveGood = YES;
        }
    }
    if (!isHaveGood) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:_goodsArray[indexPath.row] forKey:@"goodsInfo"];
        [dic setValue:@"1" forKey:@"goodsNum"];
        [dic setValue:@"1" forKey:@"isCheck"];
        [_localCartGoodsArray addObject:dic];
    }
    
    [self updateLocationCart];
}

- (void)numberMinus:(GoodsCell *)cell
{
    NSIndexPath *indexPath = [_categoryTableView indexPathForCell:cell];
    
    [_localCartGoodsArray[indexPath.row] setValue:[NSString stringWithFormat:@"%d",[_localCartGoodsArray[indexPath.row][@"goodsNum"] intValue]-1] forKey:@"goodsNum"];
    
    [self updateLocationCart];
}

//获取购物车中数据
- (void)getLocalShoppingCart
{
    self.localCartGoodsArray = [NSMutableArray array];
    if ([ReadWriteSandbox propertyFileExists:ShopCart_File_Path]) {
        self.localCartDic = [NSMutableDictionary dictionaryWithDictionary:[ReadWriteSandbox readPropertyFile:ShopCart_File_Path]];
        NSArray *cartArray = [ReadWriteSandbox readPropertyFile:ShopCart_File_Path][@"data"];
        for (int i = 0; i<[cartArray count]; i++) {
            if ([cartArray[i][@"userToken"] isEqual:[UserModel shareUserModel].userToken] && [cartArray[i][@"businessid"] isEqual:self.storeID]) {
                [self.localCartGoodsArray addObjectsFromArray:cartArray[i][@"goodsArray"]];
            }
        }
    }
}

//更新本地购物车数据
- (void)updateLocationCart
{
    //如果存在购物车plist, 更新或新增数据；如果未存在plist, 创建plist, 并新增数据
    if ([ReadWriteSandbox propertyFileExists:ShopCart_File_Path]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[ReadWriteSandbox readPropertyFile:ShopCart_File_Path]];
        NSMutableArray *cartArray = [NSMutableArray arrayWithArray:dic[@"data"]];
        BOOL isHaveUserID = NO;
        for (int i = 0; i<[cartArray count]; i++) {
            if ([cartArray[i][@"userToken"] isEqual:[UserModel shareUserModel].userToken] && [self.storeID isEqual:cartArray[i][@"businessid"]]) {
                isHaveUserID = YES;
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:cartArray[i]];
                [dict setValue:_localCartGoodsArray forKey:@"goodsArray"];
                [cartArray replaceObjectAtIndex:i withObject:dict];
            }
        }
        //如果没有该userid下的数据，新增购物车数据
        if (!isHaveUserID) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:[UserModel shareUserModel].userToken forKey:@"userToken"];
            [dict setValue:_localCartGoodsArray forKey:@"goodsArray"];
            [dict setValue:self.storeID forKey:@"businessid"];
            [cartArray addObject:dict];
        }
        
        [dic setValue:cartArray forKey:@"data"];
        [ReadWriteSandbox writePropertyFile:dic FilePath:ShopCart_File_Path];
    }else
    {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSMutableArray *cartArray = [NSMutableArray array];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:[UserModel shareUserModel].userToken forKey:@"userToken"];
        [dict setValue:_localCartGoodsArray forKey:@"goodsArray"];
        [dict setValue:self.storeID forKey:@"businessid"];
        [cartArray addObject:dict];
        
        [dic setValue:cartArray forKey:@"data"];
        [ReadWriteSandbox writePropertyFile:dic FilePath:ShopCart_File_Path];
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
