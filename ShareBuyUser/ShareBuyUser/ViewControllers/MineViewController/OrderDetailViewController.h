//
//  OrderDetailViewController.h
//  ShareBuyUser
//
//  Created by Marx on 16/8/10.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "BaseViewController.h"

@interface OrderDetailViewController : BaseViewController

@property(nonatomic,copy)NSString *orderID;
@property(nonatomic)BOOL isOffLine;

@property (nonatomic, strong) NSMutableDictionary *orderInfoDict;

@end
