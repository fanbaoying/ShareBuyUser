//
//  CollectionViewController.m
//  ShareBuyUser
//
//  Created by soldier on 16/8/23.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "CollectionViewController.h"
#import "BaseWebViewController.h"
#import "GoodsCell.h"

@interface CollectionViewController () <UITableViewDelegate,UITableViewDataSource>
{
    NSInteger currentPage;
}

@property (nonatomic, strong) UITableView *collectionTableView;
@property (nonatomic, strong) NSMutableArray *collectionArray;

@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"我的收藏"];
    
    self.collectionArray = [NSMutableArray array];
    [self.view addSubview:self.collectionTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.collectionArray = [NSMutableArray array];
    currentPage = 0;
    NSDictionary *dic = @{@"pageIndex":[NSString stringWithFormat:@"%ld",currentPage+1],@"token":[UserModel shareUserModel].userToken};
    [self getCollectionListRequestWithDict:dic];
}

- (UITableView *)collectionTableView
{
    if (!_collectionTableView) {
        _collectionTableView = ({
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
                NSDictionary *dic = @{@"pageIndex":[NSString stringWithFormat:@"%ld",currentPage+1],@"token":[UserModel shareUserModel].userToken};
                [self getCollectionListRequestWithDict:dic];
            }];
            
            tableView;
        });
    }
    return _collectionTableView;
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
    
    BaseWebViewController *baseWebVC = [[BaseWebViewController alloc] init];
    baseWebVC.webUrlStr = [NSString stringWithFormat:@"%@/app/goodsInfo/index?goodsid=%@&&state=1",BASE_URL,_collectionArray[indexPath.row][@"goodsid"]];
    baseWebVC.goodsId = _collectionArray[indexPath.row][@"goodsid"];

//    baseWebVC.goodsDic = _collectionArray[indexPath.row];
    //    baseWebVC.webUrlStr = [NSString stringWithFormat:@"%@app/goodsInfo/index?goodsid=%@&&state=1",@"http://10.58.160.112:8080/shareApp/",_goodsArray[indexPath.row][@"goodsid"]];
    [self.navigationController pushViewController:baseWebVC animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_collectionArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    GoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[GoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        cell.delegate = self;
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsZero];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell.imgView setImageWithURL:[NSURL URLWithString:_collectionArray[indexPath.row][@"imgurl"]] placeholderImage:[UIImage imageNamed:@"product_placeholder"]];
    [cell.nameLabel setText:_collectionArray[indexPath.row][@"goodsname"]];
    [cell.priceLabel setText:[NSString stringWithFormat:@"￥%.2f",[_collectionArray[indexPath.row][@"onprice"] floatValue]]];
    
    return cell;
}

#pragma mark - NetWorking
//获取用户收藏商品列表 
- (void)getCollectionListRequestWithDict:(NSDictionary *)dict
{
    [self showHudInView:self.view hint:nil];
    [DDPBLL requestWithURL:DEF_URL_GetCollectList  Dict:dict result:^(NSDictionary *responseDict) {
        [self hideHud];
        NSLog(@"%@",responseDict);
        if (responseDict == nil) {
            return ;
        }
        if ([[responseDict objectForKey:@"status"] integerValue] == 0) {
            if ([responseDict[@"data"] count] != 0) {
                [self.collectionArray addObjectsFromArray:responseDict[@"data"]];
                [_collectionTableView reloadData];
            }else
            {
                // legendFooter置为"没有更多内容了"状态
                [_collectionTableView.legendFooter noticeNoMoreData];
            }
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
