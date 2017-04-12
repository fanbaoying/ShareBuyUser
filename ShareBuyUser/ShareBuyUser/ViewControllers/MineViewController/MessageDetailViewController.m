
//
//  MessageDetailViewController.m
//  ShareBuyUser
//
//  Created by soldier on 16/8/25.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "MessageDetailViewController.h"
#import "MessageDetailCell.h"

@interface MessageDetailViewController () <UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
{
    NSInteger currentPage;
    UITextView *myTextView;
}

@property (nonatomic, strong) UITableView *messageTableView;
@property (nonatomic, strong) NSMutableArray *messageArray;

@end

@implementation MessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"消息详情"];
    
    self.messageArray = [NSMutableArray array];
    [self.view addSubview:self.messageTableView];
    
    currentPage = 0;
    NSDictionary *dict = @{@"letterid":_letterID,@"pageSize":@"10",@"pageIndex":[NSString stringWithFormat:@"%ld",currentPage+1]};
    [self getUserPrivateReplyPageRequestWithDict:dict WithRefresh:YES];
    
    [self createFooterView];
}

#pragma mark - Get Method
- (UITableView *)messageTableView
{
    if (!_messageTableView) {
        _messageTableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHight) style:UITableViewStylePlain];
            [tableView setDelegate:self];
            [tableView setDataSource:self];
            [tableView setBackgroundColor:[UIColor clearColor]];
            [tableView setTableFooterView:[UIView new]];
            [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            
            [tableView addLegendFooterWithRefreshingBlock:^{
                currentPage++;
                NSDictionary *dict = @{@"letterid":_letterID,@"pageSize":@"10",@"pageIndex":[NSString stringWithFormat:@"%ld",currentPage+1]};
                [self getUserPrivateReplyPageRequestWithDict:dict WithRefresh:NO];
            }];

            tableView;
        });
    }
    return _messageTableView;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageDetailCell *cell = (MessageDetailCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return CGRectGetHeight(cell.frame);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"选择cell");
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_messageArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MessageDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[MessageDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsZero];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.model = _messageArray[indexPath.row];
    
    return cell;
}

- (void)createFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 44 - 64, kScreenWidth, 44)];
    footerView.backgroundColor = [UIColor whiteColor];
    [_messageTableView addSubview:footerView];
    
    myTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 5, kScreenWidth - 90, 34)];
    myTextView.text = @"说点什么吧...";
    myTextView.textColor = UIColorFromHex(0xc9c9c9, 1);
    myTextView.font = UIFontPingFangLight(13);
    myTextView.delegate = self;
    myTextView.layer.cornerRadius = 5;
    myTextView.layer.masksToBounds = YES;
    myTextView.backgroundColor = UIColorFromHex(0xededed, 1);
    [footerView addSubview:myTextView];
    
    UIButton *evaluateButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(myTextView.frame)+5, CGRectGetMinY(myTextView.frame), 65, CGRectGetHeight(myTextView.frame))];
    [evaluateButton setTitleColor:UIColorFromHex(0xff5f3b, 1) forState:UIControlStateNormal];
    [evaluateButton setTitle:@"评论" forState:UIControlStateNormal];
    [evaluateButton addTarget:self action:@selector(evaluateClick) forControlEvents:UIControlEventTouchUpInside];
    evaluateButton.titleLabel.font = UIFontPingFangMedium(15);
    [footerView addSubview:evaluateButton];
}

#pragma mark - UIButton Action
- (void)evaluateClick
{
    NSLog(@"回复私信");
    
    NSDictionary *dic = @{@"token":[UserModel shareUserModel].userToken,@"letterid":_letterID,@"recipientid":_recipientID,@"content":myTextView.text};
    [self addUserPrivateReplyRequestWithDict:dic];
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    _messageTableView.contentOffset = CGPointMake(0, 250);
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    _messageTableView.contentOffset = CGPointMake(0, 0);
    
    return YES;
}

#pragma mark - Networking
//用户私信回复查询(获取私信详情) 
- (void)getUserPrivateReplyPageRequestWithDict:(NSDictionary *)dict WithRefresh:(BOOL)isRefresh
{
    if (isRefresh) {
        [_messageArray removeAllObjects];
    }
    [DDPBLL requestWithURL:DEF_URL_UserPrivateReply  Dict:dict result:^(NSDictionary *responseDict) {
        [self hideHud];
        NSLog(@"%@",responseDict);
        if (responseDict == nil) {
            return ;
        }
        if ([[responseDict objectForKey:@"status"] integerValue] == 0) {
            NSLog(@"获取私信详情成功");
            if ([dict[@"pageIndex"] integerValue] == 1) {
                if ([responseDict[@"data"] count] == 0) {
                    [_messageArray addObject:_messageDic];
                }
            }
            if ([responseDict[@"data"] count] != 0) {
                [_messageTableView.legendFooter endRefreshing];
                [_messageArray addObjectsFromArray:responseDict[@"data"]];
            }else
            {
                // legendFooter置为"没有更多内容了"状态
                [_messageTableView.legendFooter noticeNoMoreData];
            }
            [_messageTableView reloadData];
        }
        else{
            [self showHint:responseDict[@"msg"]];
        }
    }];
}

// 用户私信回复 
- (void)addUserPrivateReplyRequestWithDict:(NSDictionary *)dic
{
    [DDPBLL requestWithURL:DEF_URL_AddUserPrivateReply  Dict:dic result:^(NSDictionary *responseDict) {
        [self hideHud];
        NSLog(@"%@",responseDict);
        if (responseDict == nil) {
            return ;
        }
        if ([[responseDict objectForKey:@"status"] integerValue] == 0) {
            NSLog(@"添加私信成功");
            currentPage = 0;
            NSDictionary *dict = @{@"letterid":_letterID,@"pageSize":@"10",@"pageIndex":[NSString stringWithFormat:@"%ld",currentPage+1]};
            [self getUserPrivateReplyPageRequestWithDict:dict WithRefresh:YES];
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
