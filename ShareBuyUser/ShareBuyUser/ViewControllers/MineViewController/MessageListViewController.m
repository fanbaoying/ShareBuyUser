//
//  MessageListViewController.m
//  ShareBuyUser
//
//  Created by soldier on 16/8/23.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "MessageListViewController.h"
#import "MessageCell.h"
#import "MessageDetailViewController.h"

@interface MessageListViewController () <UITableViewDelegate,UITableViewDataSource>
{
    NSInteger currentPage;
}

@property (nonatomic, strong) UITableView *messageTableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UIView *chooseLineView;

@property (nonatomic, strong) NSMutableArray *messageArray;

@end

@implementation MessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"消息"];
    
    self.messageArray = [NSMutableArray array];
    [self.view addSubview:self.messageTableView];
    
    NSDictionary *dic = @{@"token":[UserModel shareUserModel].userToken,@"pageIndex":[NSString stringWithFormat:@"%ld",currentPage+1]};
    [self getMessageInfoListRequestWithDict:dic];
}

- (UITableView *)messageTableView
{
    if (!_messageTableView) {
        _messageTableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHight) style:UITableViewStylePlain];
            [tableView setDelegate:self];
            [tableView setDataSource:self];
            [tableView setTableHeaderView:self.headerView];
            [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            [tableView setBackgroundColor:[UIColor clearColor]];
            [tableView setTableFooterView:[UIView new]];
            [tableView setSeparatorInset:UIEdgeInsetsZero];
            [tableView setLayoutMargins:UIEdgeInsetsZero];
            
            [tableView addLegendFooterWithRefreshingBlock:^{
                if (_selectBtn.tag == 100) {
                    currentPage++;
                    NSDictionary *dic = @{@"token":[UserModel shareUserModel].userToken,@"pageIndex":[NSString stringWithFormat:@"%ld",currentPage+1]};
                    [self getMessageInfoListRequestWithDict:dic];
                }else
                {
                    NSLog(@"私信列表");
                    currentPage++;
                    NSDictionary *dic = @{@"token":[UserModel shareUserModel].userToken,@"pageIndex":[NSString stringWithFormat:@"%ld",currentPage+1],@"pageSize":@"10"};
                    [self userPrivateLetterListRequestWithDict:dic];
                }

            }];
            tableView;
        });
    }
    return _messageTableView;
}

- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
            [view setBackgroundColor:[UIColor whiteColor]];
        
            NSArray *titleArray = @[@"系统消息",@"私信"];
            for (int i = 0; i<[titleArray count]; i++) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button setFrame:CGRectMake(i*kScreenWidth/2, 0, kScreenWidth/2, 35)];
                [button setTitle:titleArray[i] forState:UIControlStateNormal];
                [button setTitleColor:UIColorFromHex(0x696969, 1) forState:UIControlStateNormal];
                [button setTitleColor:kMainColor forState:UIControlStateSelected];
                button.titleLabel.font = UIFontPingFangMedium(15.0f);
                [button setTag:(100+i)];
                [button addTarget:self action:@selector(clickMessageType:) forControlEvents:UIControlEventTouchUpInside];
                
                if (i == 0) {
                    [button setSelected:YES];
                    _selectBtn = button;
                }
                [view addSubview:button];
            }
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 34, kScreenWidth, 1)];
            [lineView setBackgroundColor:UIColorFromHex(0xcccccc, 1)];
            [view addSubview:lineView];
            
            lineView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2, 3, 1, 30)];
            [lineView setBackgroundColor:UIColorFromHex(0xcccccc, 1)];
            [view addSubview:lineView];
            
            [view addSubview:self.chooseLineView];
            
            view;
        });
    }
    return _headerView;
}

- (UIView *)chooseLineView
{
    if (!_chooseLineView) {
        _chooseLineView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 34, kScreenWidth/2, 1)];
            [view setBackgroundColor:kMainColor];
            
            view;
        });
    }
    return _chooseLineView;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"选择cell");
    if (_selectBtn.tag == 101) {
        NSLog(@"私信详情");
        MessageDetailViewController *messageDetailVC = [[MessageDetailViewController alloc] init];
        messageDetailVC.letterID = _messageArray[indexPath.row][@"id"];
        messageDetailVC.recipientID = _messageArray[indexPath.row][@"recipientid"];
        messageDetailVC.messageDic = _messageArray[indexPath.row];
        [self.navigationController pushViewController:messageDetailVC animated:YES];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_messageArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsZero];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    if (_selectBtn.tag == 100) {
        [cell.imgView setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"product_placeholder"]];
        [cell.titleLabel setText:@"系统消息"];
        [cell.contentLabel setText:_messageArray[indexPath.row][@"content"]];
    }else
    {
        [cell.imgView setImageWithURL:[NSURL URLWithString:_messageArray[indexPath.row][@"headurl"]] placeholderImage:[UIImage imageNamed:@"product_placeholder"]];
        [cell.titleLabel setText:_messageArray[indexPath.row][@"nickname"]];
        if ([_messageArray[indexPath.row][@"endcontent"] length] == 0) {
            [cell.contentLabel setText:_messageArray[indexPath.row][@"content"]];
        }else
        {
            [cell.contentLabel setText:_messageArray[indexPath.row][@"endcontent"]];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"删除消息接口");
        if (_selectBtn.tag == 100) {
            NSDictionary *dic = @{@"token":[UserModel shareUserModel].userToken,@"messageid":_messageArray[indexPath.row][@"messageid"]};
            [self deleteMessageRequestWithDict:dic WithIndex:indexPath];
        }else
        {
            NSDictionary *dic = @{@"token":[UserModel shareUserModel].userToken,@"id":_messageArray[indexPath.row][@"id"]};
            [self deleteUserPrivateLetterWithDict:dic WithIndex:indexPath];
        }
    }
}

#pragma mark - UIButton Action
- (void)clickMessageType:(UIButton *)sender
{
    currentPage = 0;
    [_messageArray removeAllObjects];
    
    [_chooseLineView setFrame:CGRectMake((sender.tag-100) * kScreenWidth/2, 34, kScreenWidth/2, 1)];

    NSLog(@"选择 消息 类型");
    if (!(sender.tag == _selectBtn.tag)) {
        [_selectBtn setSelected:NO];
        _selectBtn = sender;
        [_selectBtn setSelected:YES];
        switch (_selectBtn.tag - 100) {
            case 0:
                NSLog(@"系统消息");
            {
                NSDictionary *dic = @{@"token":[UserModel shareUserModel].userToken,@"pageIndex":[NSString stringWithFormat:@"%ld",currentPage+1]};
                [self getMessageInfoListRequestWithDict:dic];
            }
                break;
            case 1:
                NSLog(@"私信");
            {
                NSDictionary *dic = @{@"token":[UserModel shareUserModel].userToken,@"pageIndex":[NSString stringWithFormat:@"%ld",currentPage+1],@"pageSize":@"10"};
                [self userPrivateLetterListRequestWithDict:dic];
            }
                break;
                
            default:
                break;
        }
    }

}

#pragma mark - NetWorking
//系统消息列表
- (void)getMessageInfoListRequestWithDict:(NSDictionary *)dict
{
    [self showHudInView:self.view hint:nil];
    [DDPBLL requestWithURL:DEF_URL_GetMessageInfoList  Dict:dict result:^(NSDictionary *responseDict) {
        [self hideHud];
        NSLog(@"%@",responseDict);
        if (responseDict == nil) {
            [self showHint:@"处理失败，请稍后再试"];
            return ;
        }
        if ([[responseDict objectForKey:@"status"] integerValue] == 0) {
            if ([responseDict[@"data"] count] != 0) {
                [_messageArray addObjectsFromArray:responseDict[@"data"]];
            }else
            {
                // legendFooter置为"没有更多内容了"状态
                [_messageTableView.legendFooter noticeNoMoreData];
            }
            
            [_messageTableView reloadData];
        }else{
            [self showHint:responseDict[@"msg"]];
        }
    }];

}

//删除系统消息
- (void)deleteMessageRequestWithDict:(NSDictionary *)dict WithIndex:(NSIndexPath *)index
{
    [self showHudInView:self.view hint:nil];
    [DDPBLL requestWithURL:DEF_URL_DeleteMessage  Dict:dict result:^(NSDictionary *responseDict) {
        [self hideHud];
        NSLog(@"%@",responseDict);
        if (responseDict == nil) {
            [self showHint:@"处理失败，请稍后再试"];
            return ;
        }
        if ([[responseDict objectForKey:@"status"] integerValue] == 0) {
            NSLog(@"删除成功");
            [_messageArray removeObjectAtIndex:index.row];
            
            [_messageTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationFade];
        }else{
            [self showHint:responseDict[@"msg"]];
        }
    }];
}

//用户私信列表 
- (void)userPrivateLetterListRequestWithDict:(NSDictionary *)dict
{
    [self showHudInView:self.view hint:nil];
    [DDPBLL requestWithURL:DEF_URL_UserPrivateLetter  Dict:dict result:^(NSDictionary *responseDict) {
        [self hideHud];
        NSLog(@"%@",responseDict);
        if (responseDict == nil) {
            [self showHint:@"处理失败，请稍后再试"];
            return ;
        }
        if ([[responseDict objectForKey:@"status"] integerValue] == 0) {
            if ([responseDict[@"data"] count] != 0) {
                [_messageArray addObjectsFromArray:responseDict[@"data"]];
            }else
            {
                // legendFooter置为"没有更多内容了"状态
                [_messageTableView.legendFooter noticeNoMoreData];
            }
            
            [_messageTableView reloadData];
        }else{
            [self showHint:responseDict[@"msg"]];
        }
    }];
}

//用户私信删除 
- (void)deleteUserPrivateLetterWithDict:(NSDictionary *)dict WithIndex:(NSIndexPath *)index
{
    [self showHudInView:self.view hint:nil];
    [DDPBLL requestWithURL:DEF_URL_DeleteUserPrivateLetter  Dict:dict result:^(NSDictionary *responseDict) {
        [self hideHud];
        NSLog(@"%@",responseDict);
        if (responseDict == nil) {
            [self showHint:@"处理失败，请稍后再试"];
            return ;
        }
        if ([[responseDict objectForKey:@"status"] integerValue] == 0) {
            NSLog(@"删除成功");
            [_messageArray removeObjectAtIndex:index.row];
            
            [_messageTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationFade];
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
