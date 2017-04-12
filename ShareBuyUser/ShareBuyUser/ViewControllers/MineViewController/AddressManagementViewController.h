//
//  AddressManagementViewController.h
//  ShareBuyUser
//
//  Created by Marx on 16/8/17.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^returnBlock)(NSDictionary *addressDic);

@interface AddressManagementViewController : BaseViewController

@property (nonatomic, strong) returnBlock addressBlock;

- (void)chooseAddress:(returnBlock)block;

@end
