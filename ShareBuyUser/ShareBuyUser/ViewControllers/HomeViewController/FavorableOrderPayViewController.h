//
//  FavorableOrderPayViewController.h
//  ShareBuyUser
//
//  Created by soldier on 16/8/30.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "BaseViewController.h"

@interface FavorableOrderPayViewController : BaseViewController

@property (nonatomic, assign) BOOL isStore;         //店铺优惠付款
@property (nonatomic, strong) NSString *orderID;
@property (nonatomic, strong) NSDictionary *orderDic;
@property (nonatomic, strong) NSString *orderPrice;


@end
