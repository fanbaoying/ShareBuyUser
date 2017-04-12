//
//  ShareDetailsViewController.m
//  ShareBuyUser
//
//  Created by 刘兵 on 16/8/9.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "ShareDetailsViewController.h"
#import "ShareDetailsTableViewCell.h"
#import "SelectShoppingViewController.h"
#import "UserDetailsViewController.h"

@interface ShareDetailsViewController ()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>
{
    NSMutableArray *dataArray;
    UITextView *myTextView;
    UIScrollView *scrollView;
    NSInteger pageIndex;
}
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ShareDetailsViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"分享详情";
    
    dataArray = [NSMutableArray array];
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
    [self.view addSubview:scrollView];
    
    [scrollView addSubview:self.tableView];
    [self createFooterView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [dataArray removeAllObjects];
    pageIndex = 1;
    [self getTopicAppraiseRequestWithDict:@{@"topicid":_shareDic[@"topicid"],@"pageSize":@"10",@"pageIndex":@(pageIndex)}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Get Methiod

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 44) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [self createHeaderView];
        
        [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    }
    
    return _tableView;
}

#pragma mark - Action 
- (void)loadMoreData {
    NSLog(@"loadMoreData");
    pageIndex++;
    [self getTopicAppraiseRequestWithDict:@{@"topicid":_shareDic[@"topicid"],@"pageSize":@"10",@"pageIndex":@(pageIndex)}];
}

- (void)createHeaderView {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *headImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 27, 27)];
    headImg.backgroundColor = [UIColor blueColor];
    headImg.layer.cornerRadius = 13.5;
    headImg.layer.masksToBounds = YES;
    [headImg setImageWithURL:[NSURL URLWithString:_shareDic[@"headurl"]] placeholderImage:[UIImage imageNamed:@"product_placeholder"]];
    headImg.userInteractionEnabled = YES;
    [headerView addSubview:headImg];
    
    UITapGestureRecognizer *tapHead = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHead:)];
    [headImg addGestureRecognizer:tapHead];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headImg.frame)+5, CGRectGetMinY(headImg.frame), 100, CGRectGetHeight(headImg.frame))];
//    nameLabel.text = @"林允儿";
    nameLabel.text = _shareDic[@"nickname"];
    nameLabel.font = UIFontPingFangMedium(14);
    [headerView addSubview:nameLabel];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 120, CGRectGetMinY(nameLabel.frame), 100, CGRectGetHeight(nameLabel.frame))];
    dateLabel.textAlignment = NSTextAlignmentRight;
//    dateLabel.text = @"创建于04-25";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[_shareDic[@"ctime"] longLongValue]/1000];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    dateLabel.text = [NSString stringWithFormat:@"创建于%@",dateStr];
    dateLabel.font = UIFontPingFangMedium(13);
    dateLabel.textColor = UIColorFromHex(0xbbbbbb, 1);
    [headerView addSubview:dateLabel];
    
    CGRect rect = [_shareDic[@"title"] boundingRectWithSize:CGSizeMake(kScreenWidth - 20, 1000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:UIFontPingFangMedium(15)} context:nil];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(nameLabel.frame)+10, kScreenWidth - 20, rect.size.height+10)];
    titleLabel.font = UIFontPingFangMedium(15);
//    titleLabel.text = @"一起来抢购个吧！全场5折";
    titleLabel.text = _shareDic[@"title"];
    titleLabel.numberOfLines = 0;
    [headerView addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLabel.frame), kScreenWidth - 20, 0.5)];
    lineView.backgroundColor = UIColorFromHex(0xbbbbbb, 1);
    [headerView addSubview:lineView];
    
    NSString *contentStr = _shareDic[@"content"];
    CGRect rect1 = [contentStr boundingRectWithSize:CGSizeMake(kScreenWidth - 20, 1000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:UIFontPingFangMedium(14)} context:nil];
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lineView.frame)+5, kScreenWidth - 20, rect1.size.height)];
    contentLabel.text = contentStr;
    contentLabel.font = UIFontPingFangMedium(14);
    contentLabel.numberOfLines = 0;
    [headerView addSubview:contentLabel];
    
    UIScrollView *imgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(contentLabel.frame)+5, kScreenWidth - 20, (kScreenWidth - 30)/3)];
    for (int i = 0; i < [_shareDic[@"imgurl"] count]; i++) {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(((kScreenWidth - 30)/3+5)*i, 0, (kScreenWidth - 30)/3, (kScreenWidth - 30)/3)];
//        img.backgroundColor = [UIColor redColor];
        [img setImageWithURL:[NSURL URLWithString:_shareDic[@"imgurl"][i]] placeholderImage:[UIImage imageNamed:@"product_placeholder"]];
        [imgScrollView addSubview:img];
    }
    [headerView addSubview:imgScrollView];
    
    if (_isMine) {
        headerView.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetMaxY(imgScrollView.frame)+5);
    }else
    {
        UIButton *buyButton = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(imgScrollView.frame)+5, kScreenWidth - 30, 40)];
        buyButton.backgroundColor = UIColorFromHex(0xff5f3b, 1);
        buyButton.layer.cornerRadius = 5;
        buyButton.layer.masksToBounds = YES;
        [buyButton setTitle:@"去购买" forState:UIControlStateNormal];
        [buyButton addTarget:self action:@selector(buyBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        buyButton.titleLabel.font = UIFontPingFangMedium(15);
        [headerView addSubview:buyButton];
        
        headerView.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetMaxY(buyButton.frame)+5);
    }
    
    _tableView.tableHeaderView = headerView;
}

- (void)createFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 44 - 64, kScreenWidth, 44)];
    footerView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:footerView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    line.backgroundColor = UIColorFromHex(0xcccccc, 1);
    [footerView addSubview:line];
    
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

- (void)evaluateClick {
    NSLog(@"评论");
    if (myTextView.text.length == 0||[myTextView.text isEqualToString:@"说点什么吧..."]) {
        [self showHint:@"请输入评论内容" yOffset:-250];
        return;
    }
    NSDictionary *dic = @{@"topicid":_shareDic[@"topicid"],@"token":[UserModel shareUserModel].userToken,@"content":myTextView.text};
    [self AddTopicAppraiseRequestWithDict:dic];
}

- (void)buyBtnClick {
    NSLog(@"去购买");
    SelectShoppingViewController *vc = [[SelectShoppingViewController alloc] init];
    vc.shareID = [NSString stringWithFormat:@"%@",_shareDic[@"topicid"]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tapHead:(UITapGestureRecognizer *)tap {
    NSLog(@"用户详情%ld", [[tap.view superview] tag]);
    UserDetailsViewController *vc = [[UserDetailsViewController alloc] init];
    vc.userID = _shareDic[@"userid"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tapCellHead:(UITapGestureRecognizer *)tap {
    NSLog(@"用户详情%ld", [[tap.view superview] tag]);
    UserDetailsViewController *vc = [[UserDetailsViewController alloc] init];
    vc.userID = dataArray[[[tap.view superview] tag]-100][@"userid"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell";
    ShareDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ShareDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.model = dataArray[indexPath.section];
    cell.tag = indexPath.section + 100;
    UITapGestureRecognizer *tapCellHead = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCellHead:)];
    [cell.headImg addGestureRecognizer:tapCellHead];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShareDetailsTableViewCell *cell = (ShareDetailsTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return CGRectGetHeight(cell.frame);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 25;
    }
    else {
        return 0.0001;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 3;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 25)];
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, 25)];
        leftView.backgroundColor = UIColorFromHex(0xf8a38f, 1);
        [view addSubview:leftView];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 100, 25)];
        label.text = @"评论";
        label.textColor = UIColorFromHex(0xff5f3b, 1);
        label.font = UIFontPingFangMedium(15);
        [view addSubview:label];
        return view;
    }
    else {
        return nil;
    }
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.1];
//    [UIView commitAnimations];
    scrollView.contentOffset = CGPointMake(0, 250);
    textView.text = @"";
    textView.textColor = [UIColor blackColor];
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.1];
//    [UIView commitAnimations];
    scrollView.contentOffset = CGPointMake(0, 0);
    if ([textView.text isEqualToString: @""]) {
        textView.text = @"说点什么吧...";
        textView.textColor = UIColorFromHex(0xc9c9c9, 1);
    }
    
    return YES;
}

#pragma mark - Networking
//社区帖子评论列表  
- (void)getTopicAppraiseRequestWithDict:(NSDictionary *)dict
{
    [self showHudInView:self.view hint:nil];
    [DDPBLL requestWithURL:DEF_URL_TopicAppraisePage  Dict:dict result:^(NSDictionary *responseDict) {
        [self hideHud];
        NSLog(@"%@",responseDict);
        if (responseDict == nil) {
            return ;
        }
        if ([[responseDict objectForKey:@"status"] integerValue] == 0) {
            if ([responseDict[@"data"] count] > 0) {
                [dataArray addObjectsFromArray:responseDict[@"data"]];
                [_tableView.footer endRefreshing];
            }
            else {
                [_tableView.footer noticeNoMoreData];
            }
            [_tableView reloadData];
        }
        else{
            [_tableView.footer endRefreshing];
            [self showHint:responseDict[@"msg"]];
        }
    }];
}

//社区添加帖子评论 
- (void)AddTopicAppraiseRequestWithDict:(NSDictionary *)dict
{
    [self showHudInView:self.view hint:nil];
    [DDPBLL requestWithURL:DEF_URL_TopicAppraiseAdd  Dict:dict result:^(NSDictionary *responseDict) {
        [self hideHud];
        NSLog(@"%@",responseDict);
        if (responseDict == nil) {
            return ;
        }
        if ([[responseDict objectForKey:@"status"] integerValue] == 0) {
            NSLog(@"添加评论成功");
            scrollView.contentOffset = CGPointMake(0, 0);
            [myTextView resignFirstResponder];
            myTextView.text = @"";
            
            [dataArray removeAllObjects];
            pageIndex = 1;
            [self getTopicAppraiseRequestWithDict:@{@"topicid":_shareDic[@"topicid"],@"pageSize":@"10",@"pageIndex":@(pageIndex)}];
        }
        else{
            [self showHint:responseDict[@"msg"]];
        }
    }];
}

@end
