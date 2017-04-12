//
//  FillOrderViewController.h
//  ShareBuyUser
//
//  Created by soldier on 16/8/18.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "BaseViewController.h"

@interface FillOrderViewController : BaseViewController

@property (nonatomic, strong) NSMutableArray *goodsArray;
@property (nonatomic, strong) NSString *shareID;
@property (nonatomic, strong) NSString *orderType;
@property (nonatomic, assign) BOOL isShopCartOrder;    //是否由购物车提交订单

@end
