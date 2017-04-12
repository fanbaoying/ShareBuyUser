//
//  BaseTabBarController.m
//  ShareBuyUser
//
//  Created by soldier on 16/8/8.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "BaseTabBarController.h"

@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

+ (BaseTabBarController *)shareTabBarController
{
    static BaseTabBarController *_tabBarConteroller = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _tabBarConteroller = [[BaseTabBarController alloc] init];
    });
    return _tabBarConteroller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    [backItem setTitle:@""];
    //    [backItem setBackButtonBackgroundImage:[UIImage imageNamed:@"back_arrow_image"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.navigationItem.backBarButtonItem =backItem;
    [self setTitle:@"分享购"];

    [self customView];
}

#pragma mark CustomView
- (void)customView
{
    _homeViewController = [HomeViewController new];
    _communityViewController = [CommunityViewController new];
    _shoppingCartViewController = [ShoppingCartViewController new];
    _mineViewController = [MineViewController new];
    
    self.delegate = self;
    
    self.viewControllers = [NSArray arrayWithObjects:_homeViewController, _communityViewController, _shoppingCartViewController, _mineViewController, nil];
    [self.tabBar setBarTintColor:[UIColor whiteColor]];
    
    [self.tabBar setTranslucent:NO];
    [self.tabBar setShadowImage:[[UIImage alloc]init]];
    [self.tabBar setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(0xfefefe, 0.1) size:CGSizeMake(1, 1)]];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromHex(0x999999, 1)} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: kMainColor} forState:UIControlStateSelected];
    
    NSArray *tabbarNormalImageArray = @[@"tabbar_home_normal",@"tabbar_community_normal",@"tabbar_shoppingcart_normal",@"tabbar_mine_normal"];
    NSArray *tabbarSelectedImageArray = @[@"tabbar_home_selected",@"tabbar_community_selected",@"tabbar_shoppingcart_selected",@"tabbar_mine_selected"];
    NSArray *tabbarTitleArray = @[@"首页",@"社区",@"购物车",@"我的"];
    for (int i =0; i<tabbarNormalImageArray.count; i++) {
        UITabBarItem *item = self.tabBar.items[i];
        [item setImage:[[UIImage imageNamed:tabbarNormalImageArray[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item setSelectedImage:[[UIImage imageNamed:tabbarSelectedImageArray[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item setTitle:tabbarTitleArray[i]];
        [item setTag:100+i];
    }
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    [lineView setBackgroundColor:UIColorFromHex(0xbbbbbb, 1)];
    [self.tabBar addSubview:lineView];
    
    self.navigationItem.leftBarButtonItem = _homeViewController.areaBarBtnItem;
    self.navigationItem.rightBarButtonItem = _homeViewController.scanBarBtnItem;
    self.navigationItem.titleView = _homeViewController.searchButton;
}

#pragma mark TabBarController Delegate
/*
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    self.navigationItem.titleView = nil;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    
    switch (item.tag) {
        case 100:
//            [self setTitle:@"分享购"];
            self.navigationItem.leftBarButtonItem = _homeViewController.areaBarBtnItem;
            self.navigationItem.rightBarButtonItem = _homeViewController.scanBarBtnItem;
            self.navigationItem.titleView = _homeViewController.searchButton;
            break;
        case 101:
            [self setTitle:@"社区"];
            break;
        case 102:
            [self setTitle:@"购物车"];
            self.navigationItem.rightBarButtonItem = _shoppingCartViewController.clearBarBtnItem;
            break;
        case 103:
            [self setTitle:@"我的"];
            self.navigationItem.leftBarButtonItem = _mineViewController.settingBarButtonItem;
            self.navigationItem.rightBarButtonItem = _mineViewController.messageBarButtonItem;
            break;

        default:
            break;
    }
}
 */

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    self.navigationItem.titleView = nil;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    
    if ([viewController isEqual:_shoppingCartViewController]) {
        if (![UserModel ifLogin]) {
            LoginViewController * vc = [[LoginViewController alloc] init];
            BaseNavController *nav = [[BaseNavController alloc] initWithRootViewController:vc];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
            return NO;
        }else
        {
            [self setTitle:@"购物车"];
            self.navigationItem.rightBarButtonItem = _shoppingCartViewController.clearBarBtnItem;
        }
    }else if([viewController isEqual:_homeViewController])
    {
        self.navigationItem.leftBarButtonItem = _homeViewController.areaBarBtnItem;
        self.navigationItem.rightBarButtonItem = _homeViewController.scanBarBtnItem;
        self.navigationItem.titleView = _homeViewController.searchButton;
    }
    else if([viewController isEqual:_communityViewController])
    {
        [self setTitle:@"社区"];
    }
    else if([viewController isEqual:_mineViewController])
    {
        self.navigationItem.leftBarButtonItem = _mineViewController.settingBarButtonItem;
        self.navigationItem.rightBarButtonItem = _mineViewController.messageBarButtonItem;
    }
    
    return YES;
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
