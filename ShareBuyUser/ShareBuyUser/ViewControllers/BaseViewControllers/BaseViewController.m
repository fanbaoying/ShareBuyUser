//
//  BaseViewController.m
//  ShareBuyUser
//
//  Created by soldier on 16/8/8.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColorFromHex(0xf6f6f6, 1);
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    [backItem setTitle:@""];
    //    [backItem setBackButtonBackgroundImage:[UIImage imageNamed:@"back_arrow_image"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.navigationItem.backBarButtonItem =backItem;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    _nodataView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
    [_nodataView setDelegate:self];
    [_nodataView setHidden:YES];
    [self.view addSubview:_nodataView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.nav.alphaView setAlpha:1];
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setTextColor:UIColorFromHex(0x3c3c3c, 1)];
            [label setFont:UIFontPingFangLight(17)];
            label;
        });
        
    }
    return _titleLabel;
}

- (BaseViewController *)nav
{
    if (!_nav) {
        _nav = ({
            BaseNavController *nav = (BaseNavController *)self.navigationController;
            nav;
        });
    }
    return _nav;
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
