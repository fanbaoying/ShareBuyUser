//
//  AFClient.m
//  ShareBuyUser
//
//  Created by soldier on 16/8/8.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "AFClient.h"

@implementation AFClient

+ (instancetype)sharedClient
{
    static AFClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFClient alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    });
    
    _sharedClient.responseSerializer = [AFHTTPResponseSerializer serializer];
    _sharedClient.requestSerializer.timeoutInterval = 20.0f;
    
    return _sharedClient;
}


@end
