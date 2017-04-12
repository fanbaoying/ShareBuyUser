//
//  BaseNavController.m
//  ShareBuyUser
//
//  Created by soldier on 16/8/8.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "BaseNavController.h"
#import "UIImage+Color.h"

@interface BaseNavController ()

@end

@implementation BaseNavController

-(id)initWithRootViewController:(UIViewController *)rootViewController{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [self.view insertSubview:self.alphaView belowSubview:self.navigationBar];
        [self.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(1, 1)] forBarMetrics:UIBarMetricsCompact];
        
        self.navigationBar.layer.masksToBounds = YES;
        self.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationBar.titleTextAttributes =
        @{NSForegroundColorAttributeName: [UIColor whiteColor],
          NSFontAttributeName: UIFontPingFangRegular(18.5)};
        // 去掉navigationBar底部灰线
        self.navigationBar.shadowImage = [UIImage new];
        [self.navigationBar setBackgroundImage:[UIImage new]
                                 forBarMetrics:UIBarMetricsDefault];
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
        
    }
    return self;
}

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    
//    self.navigationBar.titleTextAttributes =
//    @{NSForegroundColorAttributeName: [UIColor whiteColor],
//      NSFontAttributeName: UIFontPingFangRegular(18.5)};
//    
//    self.navigationBar.barTintColor = kMainColor;
//    self.navigationBar.tintColor = [UIColor whiteColor];
//    
//    self.navigationBar.translucent = NO;
//    
//    // 去掉navigationBar底部灰线
//    self.navigationBar.shadowImage = [UIImage new];
//    [self.navigationBar setBackgroundImage:[UIImage new]
//                             forBarMetrics:UIBarMetricsDefault];
//    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//}

- (UIView *)alphaView
{
    if (!_alphaView) {
        _alphaView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.navigationBar.frame.size.width, self.navigationBar.frame.size.height+20)];
            [view setBackgroundColor:kMainColor];
            view;
        });
    }
    return _alphaView;
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
