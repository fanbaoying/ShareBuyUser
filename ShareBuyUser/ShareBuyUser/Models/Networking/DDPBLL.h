//
//  DDPBLL.h
//  ShareBuyUser
//
//  Created by soldier on 16/8/8.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFClient.h"

@interface DDPBLL : NSObject

+ (NSURLSessionDataTask *)requestWithURL:(NSString*)url Dict:(NSDictionary *)dict result:(void (^)(NSDictionary *responseDict))block;

+ (NSURLSessionDataTask *)requestWithURL:(NSString *)url Dict:(NSDictionary *)dict andImage:(UIImage *)image andBlock:(void (^)(NSDictionary *))block;

@end
