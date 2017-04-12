//
//  StoreDetailViewController.m
//  ShareBuyUser
//
//  Created by soldier on 16/8/10.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "StoreDetailViewController.h"
#import "StoreDetailCell.h"
#import "StoreCategoryViewController.h"
#import "FavorablePayViewController.h"

@interface StoreDetailViewController () <UITableViewDelegate,UITableViewDataSource>
{
    NSInteger currentPage;
}

@property (nonatomic, strong) UITableView *storeTableView;
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) UIImageView *storeImgView;
@property (nonatomic, strong) NSMutableArray *categoryArray;

@end

@implementation StoreDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self setTitle:@"商家详情"];
    
    [self.view addSubview:self.storeTableView];
    
    currentPage = 0;
    NSDictionary *dic = @{@"pageIndex":[NSString stringWithFormat:@"%ld",currentPage+1],@"businessid":self.storeID};
    [self findBusinessCategoryRequestWithDict:dic];
}

#pragma mark - Get Method
- (UITableView *)storeTableView
{
    if (!_storeTableView) {
        _storeTableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHight) style:UITableViewStylePlain];
            [tableView setDelegate:self];
            [tableView setDataSource:self];
            [tableView setBackgroundColor:[UIColor clearColor]];
            [tableView setTableHeaderView:self.tableHeaderView];
            [tableView setTableFooterView:[UIView new]];
            [tableView setSeparatorInset:UIEdgeInsetsZero];
            [tableView setLayoutMargins:UIEdgeInsetsZero];
            [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            
            [tableView addLegendFooterWithRefreshingBlock:^{
                currentPage++;
                NSDictionary *dic = @{@"pageIndex":[NSString stringWithFormat:@"%ld",currentPage+1],@"businessid":@""};
                [self findBusinessCategoryRequestWithDict:dic];
            }];
            
            tableView;
        });
    }
    return _storeTableView;
}

- (UIView *)tableHeaderView
{
    if (!_tableHeaderView) {
        _tableHeaderView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 210)];
            [view setBackgroundColor:[UIColor whiteColor]];
            
            [view addSubview:self.storeImgView];
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, 140+15, kScreenWidth-40, 35)];
            [button setBackgroundImage:[UIImage imageWithColor:kMainColor size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 3.0f;
            [button setTitle:@"优惠付款" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.font = UIFontPingFangMedium(15.0f);
            [button addTarget:self action:@selector(clickPaymentBtn:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:button];
            
            view;
        });
    }
    return _tableHeaderView;
}

- (UIImageView *)storeImgView
{
    if (!_storeImgView) {
        _storeImgView = ({
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 140)];
            [imageView setImageWithURL:[NSURL URLWithString:self.imgUrlStr] placeholderImage:[UIImage imageNamed:@"product_placeholder"]];

            imageView;
        });
    }
    return _storeImgView;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"选择cell");
    StoreCategoryViewController *storeCategoryVC = [[StoreCategoryViewController alloc] init];
    storeCategoryVC.storeID = self.storeID;
    storeCategoryVC.categoryID = _categoryArray[indexPath.row][@"categoryid"];
    [self.navigationController pushViewController:storeCategoryVC animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_categoryArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    StoreDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[StoreDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsZero];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell.categoryNameLabel setText:_categoryArray[indexPath.row][@"categoryname"]];
    
    return cell;
}

#pragma mark - UIButton Action
- (void)clickPaymentBtn:(UIButton *)sender
{
    NSLog(@"优惠付款");
    FavorablePayViewController *favorablePayVc = [[FavorablePayViewController alloc] init];
    favorablePayVc.storeId = self.storeID;
    favorablePayVc.imgUrlStr = self.imgUrlStr;
    [self.navigationController pushViewController:favorablePayVc animated:YES];
}

#pragma mark - NetWorking
//查询店铺分类
- (void)findBusinessCategoryRequestWithDict:(NSDictionary *)dict
{
    [self showHudInView:self.view hint:nil];
    [DDPBLL requestWithURL:DEF_URL_FindBusiCategory  Dict:dict result:^(NSDictionary *responseDict) {
        [self hideHud];
        NSLog(@"%@",responseDict);
        if (responseDict == nil) {
            return ;
        }
        if ([[responseDict objectForKey:@"status"] integerValue] == 0) {
            if ([responseDict[@"data"] count] != 0) {
                self.categoryArray = [NSMutableArray arrayWithArray:responseDict[@"data"]];
                [_storeTableView reloadData];
            }else
            {
                // legendFooter置为"没有更多内容了"状态
                [_storeTableView.legendFooter noticeNoMoreData];
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
