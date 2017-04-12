//
//  HelpCenterViewController.m
//  ShareBuyUser
//
//  Created by Marx on 16/8/22.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "HelpCenterViewController.h"

@interface HelpCenterViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic)UITableView *helpCenterTableView;
@property (nonatomic, strong) NSMutableArray *helpCenterArray;

@end

@implementation HelpCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"帮助中心"];

    [self customView];
    [self getCustomerServiceRequest];
}

#pragma mark Custom View
- (void)customView
{
    [self.view addSubview:self.helpCenterTableView];
}

- (UITableView *)helpCenterTableView
{
    if (!_helpCenterTableView) {
        _helpCenterTableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHight) style:UITableViewStyleGrouped];
            [tableView setDelegate:self];
            [tableView setDataSource:self];
            [tableView setBackgroundColor:[UIColor clearColor]];
            tableView;
        });
    }
    return _helpCenterTableView;
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_helpCenterArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"SettingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_arrow_right_image"]];
        [cell.textLabel setFont:UIFontPingFangRegular(15)];
        [cell.textLabel setTextColor:UIColorFromHex(0x3c3c3c, 1)];
        [cell.detailTextLabel setFont:UIFontPingFangRegular(15)];
        [cell.detailTextLabel setTextColor:UIColorFromHex(0x696969, 1)];
        
    }
    [cell.textLabel setText:@"客服电话"];
    [cell.imageView setImage:[UIImage imageNamed:@"help_phone_image"]];
//    [cell.detailTextLabel setText:@"400-123-123"];
    [cell.detailTextLabel setText:_helpCenterArray[indexPath.row]];
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",_helpCenterArray[indexPath.row]]]];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Networking
//客服联系方式  
- (void)getCustomerServiceRequest
{
    [DDPBLL requestWithURL:DEF_URL_GetCustomerService  Dict:nil result:^(NSDictionary *responseDict) {
        [self hideHud];
        NSLog(@"%@",responseDict);
        if (responseDict == nil) {
            return ;
        }
        if ([[responseDict objectForKey:@"status"] integerValue] == 0) {
            NSLog(@"获取客服联系方式成功");
            _helpCenterArray = [NSMutableArray arrayWithObject:responseDict[@"data"][@"contact"]];
            [_helpCenterTableView reloadData];
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
