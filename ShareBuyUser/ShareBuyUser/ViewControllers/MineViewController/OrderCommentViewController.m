//
//  OrderCommentViewController.m
//  ShareBuyUser
//
//  Created by Marx on 16/8/16.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "OrderCommentViewController.h"

#import "OrderCommentTableViewCell.h"

@interface OrderCommentViewController () <UITableViewDelegate,UITableViewDataSource,OrderCommentTableViewCellDelegate>

@property(nonatomic)UITableView *orderCommentTableView;
@property(nonatomic)UIBarButtonItem *submitBarBtnItem;
@property(nonatomic)NSMutableArray *commentArray;

@end

@implementation OrderCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"评价"];
    [self initData];
    [self customView];
}
#pragma mark InitData
- (void)initData
{
    _commentArray = [[NSMutableArray alloc] init];
    if (_isGoodsList) {
        for (int i = 0; i<[_orderDic[@"goodsList"] count]; i++) {
            NSMutableDictionary *mDic = [[NSMutableDictionary alloc] init];
            [mDic setObject:_orderDic[@"goodsList"][i][@"ordergoodsid"] forKey:@"gID"];
            [mDic setObject:@"0" forKey:@"star"];
            [mDic setObject:@"" forKey:@"content"];
            
            [_commentArray addObject:mDic];
        }
    }else
    {
        for (int i = 0; i<[_orderDic[@"listTO"] count]; i++) {
            NSMutableDictionary *mDic = [[NSMutableDictionary alloc] init];
            [mDic setObject:_orderDic[@"listTO"][i][@"ordergoodsid"] forKey:@"gID"];
            [mDic setObject:@"0" forKey:@"star"];
            [mDic setObject:@"" forKey:@"content"];
            
            [_commentArray addObject:mDic];
        }
    }
}

#pragma mark Custom View
- (void)customView
{
    [self.view addSubview:self.orderCommentTableView];
    self.navigationItem.rightBarButtonItem = self.submitBarBtnItem;
}

- (UITableView *)orderCommentTableView
{
    if (!_orderCommentTableView) {
        _orderCommentTableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHight) style:UITableViewStylePlain];
            [tableView setBackgroundColor:[UIColor clearColor]];
            [tableView setDelegate:self];
            [tableView setDataSource:self];
            [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            
            tableView;
        });
    }
    return _orderCommentTableView;
}

- (UIBarButtonItem *)submitBarBtnItem
{
    if (!_submitBarBtnItem) {
        _submitBarBtnItem = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(0, 0, 40, 20)];
            [button setTitle:@"提交" forState:UIControlStateNormal];
            button.titleLabel.font = UIFontPingFangMedium(14.0f);
            [button addTarget:self action:@selector(clickComment:) forControlEvents:UIControlEventTouchUpInside];
            
            UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:button];
            barBtnItem;
        });
    }
    return _submitBarBtnItem;
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isGoodsList) {
        return [_orderDic[@"goodsList"] count];
    }else
    {
        return [_orderDic[@"listTO"] count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 220;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"MineCell";
    OrderCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[OrderCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setDelegate:self];
    }
    if (_isGoodsList) {
        [cell.goodImageView setImageWithURL:[NSURL URLWithString:_orderDic[@"goodsList"][indexPath.row][@"imgurl"]] placeholderImage:[UIImage imageNamed:@"product_placeholder"]];
        [cell.goodNameLabel setText:_orderDic[@"goodsList"][indexPath.row][@"goodsname"]];
    }else
    {
        [cell.goodImageView setImageWithURL:[NSURL URLWithString:_orderDic[@"listTO"][indexPath.row][@"imgurl"]] placeholderImage:[UIImage imageNamed:@"product_placeholder"]];
        [cell.goodNameLabel setText:_orderDic[@"listTO"][indexPath.row][@"goodsname"]];
    }
    
    [cell setStarValue:[_commentArray[indexPath.row][@"star"] integerValue]];
    return cell;
}

#pragma mark - OrderCommentTableViewCellDelegate
- (void)orderCommentTableViewCell:(OrderCommentTableViewCell *)cell changeStar:(NSInteger)star
{
    NSLog(@"选择星级");
    NSIndexPath *indexPath = [_orderCommentTableView indexPathForCell:cell];
    
    NSMutableDictionary *mDic = _commentArray[indexPath.row];
    [mDic setObject:[NSString stringWithFormat:@"%ld",star] forKey:@"star"];
    
    [_commentArray replaceObjectAtIndex:indexPath.row withObject:mDic];
}


#pragma mark - UIButton Action
- (void)clickComment:(UIButton *)button
{
    NSLog(@"评价");
    for (int i = 0; i<[_commentArray count]; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        OrderCommentTableViewCell *cell = [_orderCommentTableView cellForRowAtIndexPath:indexPath];
        
        if ([cell.contentTextView.text length] == 0) {
            [self showHint:@"评论不能为空" yOffset:-250];
            return;
        }else
        {
            NSMutableDictionary *mDic = _commentArray[i];
            [mDic setObject:cell.contentTextView.text forKey:@"content"];
            [_commentArray replaceObjectAtIndex:i withObject:mDic];
        }
    }
    
    NSString *contentStr = @"";
    for (int i = 0; i<[_commentArray count]; i++) {
        if ([_commentArray[i][@"star"] integerValue] == 0) {
            [self showHint:@"星级不能为空" yOffset:-250];
            return;
        }else
        {
            contentStr = [contentStr stringByAppendingFormat:@"%@@%@@%@#",_commentArray[i][@"gID"],_commentArray[i][@"star"],_commentArray[i][@"content"]];
        }
    }
    
    NSDictionary *dic = @{@"token":[UserModel shareUserModel].userToken,@"oid":_orderDic[@"oid"],@"content":contentStr};
    [self appraiseOrderRequestWithDict:dic];
}

#pragma mark - Networking 
- (void)appraiseOrderRequestWithDict:(NSDictionary *)dict
{
    [self showHudInView:self.view hint:nil];
    [DDPBLL requestWithURL:DEF_URL_AppraiseOrder  Dict:dict result:^(NSDictionary *responseDict) {
        [self hideHud];
        NSLog(@"%@",responseDict);
        if (responseDict == nil) {
            [self showHint:@"处理失败，请稍后再试"];
            return ;
        }
        if ([[responseDict objectForKey:@"status"] integerValue]==0) {
            NSLog(@"评价成功");
            [self.navigationController popViewControllerAnimated:YES];
        }else{
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
