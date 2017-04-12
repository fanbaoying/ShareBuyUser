//
//  GoodsCommentViewController.m
//  ShareBuyUser
//
//  Created by soldier on 16/9/7.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "GoodsCommentViewController.h"
#import "GoodsCommentCell.h"

@interface GoodsCommentViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *commentTableView;
@property (nonatomic, strong) NSMutableArray *commentArray;

@end

@implementation GoodsCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"商品评价";
    
    [self.view addSubview:self.commentTableView];
    
    NSDictionary *dic = @{@"goodsid":self.goodsID};
    [self getGoodsAppraiseRequestWithDict:dic];
}

#pragma mark - Get Method
- (UITableView *)commentTableView
{
    if (!_commentTableView) {
        _commentTableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight- kNavigationBarHight) style:UITableViewStylePlain];
            [tableView setDelegate:self];
            [tableView setDataSource:self];
            [tableView setBackgroundColor:[UIColor clearColor]];
            [tableView setTableFooterView:[UIView new]];
            [tableView setSeparatorInset:UIEdgeInsetsZero];
            [tableView setLayoutMargins:UIEdgeInsetsZero];
            [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
            
            tableView;
        });
    }
    return _commentTableView;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_commentArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    GoodsCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[GoodsCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.model = _commentArray[indexPath.row];
    
    return cell;
}



#pragma mark - Networking
//获得商品评价
- (void)getGoodsAppraiseRequestWithDict:(NSDictionary *)dict
{
    [self showHudInView:self.view hint:nil];
    [DDPBLL requestWithURL:DEF_URL_GetGoodsAppraise  Dict:nil result:^(NSDictionary *responseDict) {
        [self hideHud];
        NSLog(@"%@",responseDict);
        if (responseDict == nil) {
            return ;
        }
        if ([[responseDict objectForKey:@"status"] integerValue] == 0) {
            self.commentArray = [NSMutableArray arrayWithArray:responseDict[@"data"]];
            [_commentTableView reloadData];
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
