//
//  UserModel.h
//  ShareBuyUser
//
//  Created by Marx on 16/8/11.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

+ (UserModel *)shareUserModel;

@property(nonatomic)NSString *userToken;

@property(nonatomic)NSString *userID;
@property(nonatomic)NSString *userNick;
@property(nonatomic)NSString *userPhone;
@property(nonatomic)NSString *userAvatar;



+ (BOOL)ifLogin;

+ (void)logoff;

@end
