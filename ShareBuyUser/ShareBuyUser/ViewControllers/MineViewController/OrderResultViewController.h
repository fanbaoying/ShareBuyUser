//
//  OrderResultViewController.h
//  ShareBuyUser
//
//  Created by soldier on 16/8/29.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "BaseViewController.h"

@interface OrderResultViewController : BaseViewController

@property (nonatomic, strong) NSMutableDictionary *orderDict;
@property (nonatomic, strong) NSString *paymentStr;
@property (nonatomic, strong) NSString *orderType;

@property (nonatomic, strong) NSString *orderPrice;
@property (nonatomic, strong) NSString *orderid;

@property (nonatomic, strong) UIBarButtonItem *shareBarBtnItem;

@end
