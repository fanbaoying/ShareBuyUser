//
//  BaseTabBarController.h
//  ShareBuyUser
//
//  Created by soldier on 16/8/8.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HomeViewController.h"
#import "CommunityViewController.h"
#import "ShoppingCartViewController.h"
#import "MineViewController.h"

#import "UIImage+Color.h"

@interface BaseTabBarController : UITabBarController <UITabBarControllerDelegate>

+ (BaseTabBarController *)shareTabBarController;

@property (nonatomic, strong) HomeViewController *homeViewController;
@property (nonatomic, strong) CommunityViewController *communityViewController;
@property (nonatomic, strong) ShoppingCartViewController *shoppingCartViewController;
@property (nonatomic, strong) MineViewController *mineViewController;

@end
