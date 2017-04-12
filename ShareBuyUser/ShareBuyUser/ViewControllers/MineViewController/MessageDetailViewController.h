//
//  MessageDetailViewController.h
//  ShareBuyUser
//
//  Created by soldier on 16/8/25.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "BaseViewController.h"

@interface MessageDetailViewController : BaseViewController

@property (nonatomic, strong) NSDictionary *messageDic;
@property (nonatomic, strong) NSString *letterID;
@property (nonatomic, strong) NSString *recipientID;

@end
