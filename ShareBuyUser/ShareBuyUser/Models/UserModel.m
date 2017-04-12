//
//  UserModel.m
//  ShareBuyUser
//
//  Created by Marx on 16/8/11.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

+ (UserModel *)shareUserModel
{
    static UserModel *_userModel = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _userModel = [[UserModel alloc] init];
    });
    return _userModel;
}

- (void)setUserToken:(NSString *)userToken
{
    [[NSUserDefaults standardUserDefaults] setObject:userToken forKey:@"userToken"];
}
- (void)setUserID:(NSString *)userID
{
    [[NSUserDefaults standardUserDefaults] setObject:userID forKey:@"userID"];
}
- (void)setUserNick:(NSString *)userNick
{
    [[NSUserDefaults standardUserDefaults] setObject:userNick forKey:@"userNick"];
}

- (void)setUserAvatar:(NSString *)userAvatar
{
    [[NSUserDefaults standardUserDefaults] setObject:userAvatar forKey:@"userAvatar"];
}

- (NSString *)userToken
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"]) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"];
    }else{
        return @"";
    }
}

- (NSString *)userNick
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userNick"];
}

- (NSString *)userAvatar
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userAvatar"];
}

- (NSString *)userID
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
}

+ (BOOL)ifLogin
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"]) {
        return YES;
    }else{
        return NO;
    }
}

+ (void)logoff
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userToken"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userID"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userAvatar"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userNick"];
}


@end
