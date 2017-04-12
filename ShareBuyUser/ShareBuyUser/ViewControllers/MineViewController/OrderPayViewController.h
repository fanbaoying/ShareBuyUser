//
//  OrderPayViewController.h
//  ShareBuyUser
//
//  Created by Marx on 16/8/22.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "BaseViewController.h"

@interface OrderPayViewController : BaseViewController

@property(nonatomic)NSDictionary *orderDic;
@property (nonatomic, strong) NSString *orderType;
@property (nonatomic, strong) NSString* shareID;

@end
