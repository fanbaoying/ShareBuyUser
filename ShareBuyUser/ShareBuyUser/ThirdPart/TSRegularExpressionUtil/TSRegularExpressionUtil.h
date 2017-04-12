//
//  TSRegularExpressionUtil.h
//  FlowerSaid
//
//  Created by soldier on 16/1/27.
//  Copyright © 2016年 FlowerSaid. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    error_username = 0,
    error_password,
    error_verificationcode,
    success,
    verificationcodesuccess,
    inputTypecount
}inputType;

@interface TSRegularExpressionUtil : NSObject

//邮箱
+ (BOOL) validateEmail:(NSString *)email;
//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile;
//密码
+ (BOOL) validatePassword:(NSString *)passWord;
//verifyCode
+ (BOOL) validateVerifyCode: (NSString *)verifyCode;
//中英文，数字，1-20字符
+ (BOOL) validateText:(NSString *)text;
+ (BOOL) validateSixToTwenty:(NSString *)text;
//中文1-200字符
+ (BOOL) validateFeedBack:(NSString *)text;
//身份证
+ (BOOL) validateIdentityCard: (NSString *)identityCard;
+(BOOL) validateName:(NSString *)nameStr;


@end
