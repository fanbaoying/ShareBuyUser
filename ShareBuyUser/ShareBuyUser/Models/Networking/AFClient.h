//
//  AFClient.h
//  ShareBuyUser
//
//  Created by soldier on 16/8/8.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"

@interface AFClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end
