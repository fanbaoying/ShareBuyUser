//
//  WeChatPayMethodsUtils.h
//  ShareBuyUser
//
//  Created by soldier on 16/9/18.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "WeChatPayMethodsUtils.h"

@implementation WeChatPayMethodsUtils

//请求微信支付预订单号
-(void) wechatPaymentWithPrepayid:(NSString *) prepayid{
    
    PayReq* req             = [[PayReq alloc] init];
    req.partnerId           = WeiXin_merchantid;
    req.prepayId            = prepayid;
    req.nonceStr            = [self ret32bitString];
    req.timeStamp           = [self getTimeStamp];
    req.package             = @"Sign=WXPay";
    
    NSString * tempStr = [NSString stringWithFormat:@"appid=%@&noncestr=%@&package=%@&partnerid=%@&prepayid=%@&timestamp=%u&key=%@",WeiXin_appid,req.nonceStr,req.package,req.partnerId,req.prepayId,(unsigned int)req.timeStamp,WeiXin_privatekey];
    
    NSString * resultStr = [self MD5ByAStr:tempStr];
    resultStr = resultStr.uppercaseString;
    
    NSLog(@"signString is =%@",resultStr);
    
    req.sign = resultStr;
    
    [WXApi sendReq:req];
    //日志输出
    NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",WeiXin_appid,req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
}

-(int) getTimeStamp{
    //获取系统当前时区时间
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    //得到系统当前时区时间与GMT时间的偏差值
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    
    NSTimeInterval timeInterval = [localeDate timeIntervalSince1970];
    return [[NSNumber numberWithDouble:timeInterval] intValue];
}

- (NSString *)MD5ByAStr:(NSString *)aSourceStr {
    const char* cStr = [aSourceStr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (NSInteger i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x", result[i]];
    }
    
    return ret;
}

//获取随即32位字符串
- (NSString *)ret32bitString
{
    NSString *string = [[NSString alloc]init];
    for (int i = 0; i < 32; i++) {
        int number = arc4random() % 36;
        if (number < 10) {
            int figure = arc4random() % 10;
            NSString *tempString = [NSString stringWithFormat:@"%d", figure];
            string = [string stringByAppendingString:tempString];
        }else {
            int figure = (arc4random() % 26) + 97;
            char character = figure;
            NSString *tempString = [NSString stringWithFormat:@"%c", character];
            string = [string stringByAppendingString:tempString];
        }
    }
    return string;
}

@end
