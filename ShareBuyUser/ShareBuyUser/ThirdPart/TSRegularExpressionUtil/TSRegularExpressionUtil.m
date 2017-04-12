//
//  TSRegularExpressionUtil.m
//  FlowerSaid
//
//  Created by soldier on 16/1/27.
//  Copyright © 2016年 FlowerSaid. All rights reserved.
//

#import "TSRegularExpressionUtil.h"

@implementation TSRegularExpressionUtil

//邮箱
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile
{
    NSString *phoneRegex = @"^^[1][358][0-9]{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}
//密码
+ (BOOL) validatePassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[A-Za-z0-9]{6,16}$";//@"^[A-Za-z0-9]{6,20}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}
//verifyCode
+ (BOOL) validateVerifyCode: (NSString *)verifyCode
{
    BOOL flag;
    if (!(verifyCode.length == 6)) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{6})";
    NSPredicate *verifyCodePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [verifyCodePredicate evaluateWithObject:verifyCode];
}

//中英文，数字，1-20字符
+ (BOOL) validateText:(NSString *)text
{
    NSString *regex = @"^[a-zA-Z0-9\u4e00-\u9fa5]{1,20}+$";
    NSPredicate *textTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [textTest evaluateWithObject:text];
}

+ (BOOL) validateSixToTwenty:(NSString *)text
{
    NSString *regex = @"^[a-zA-Z\u4e00-\u9fa5]{6,20}+$";
    NSPredicate *textTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [textTest evaluateWithObject:text];
}

+ (BOOL) validateFeedBack:(NSString *)text {
    NSString *regex = @"^[\u4e00-\u9fa5]+$";
    NSPredicate *textTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [textTest evaluateWithObject:text];
}

+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

+(BOOL) validateName:(NSString *)nameStr{
    //at least one number, at least one special symbol, 8-32 characters long
    
    NSCharacterSet *specialChars = [NSCharacterSet characterSetWithCharactersInString:@"!@#$%^&*()[]`=-:_<>,"];
    NSRange rang;
    rang = [nameStr rangeOfCharacterFromSet:specialChars];
    if(!rang.length){
        return NO;
        // return false;
    }
    return YES;
}


@end
