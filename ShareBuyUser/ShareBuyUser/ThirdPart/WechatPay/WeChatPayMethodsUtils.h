//
//  WeChatPayMethodsUtils.h
//  ShareBuyUser
//
//  Created by soldier on 16/9/18.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WechatAuthSDK.h"
#import "WXApiObject.h"
#import "WXApi.h"
#import <CommonCrypto/CommonDigest.h> // Need to import for CC_MD5 access

@interface WeChatPayMethodsUtils : NSObject

-(void) wechatPaymentWithPrepayid:(NSString *) prepayid;

@end
