//
//  ReadWriteSandbox.m
//  ShareBuyUser
//
//  Created by soldier on 16/8/16.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "ReadWriteSandbox.h"

@implementation ReadWriteSandbox

// 判断程序沙盒文件是否存在
+ (BOOL) propertyFileExists:(NSString *) filePath
{
    return ([[NSFileManager defaultManager] fileExistsAtPath:filePath]);
}

//读取程序沙盒文件
+ (NSMutableDictionary *)readPropertyFile:(NSString *) filePath
{
    NSMutableDictionary *contentDic = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    return contentDic;
}

// 写入程序沙盒文件i
+ (BOOL) writePropertyFile:(NSMutableDictionary *) writeData FilePath:(NSString *) filePath
{
    return ([writeData writeToFile:filePath atomically:YES]);
}

// 删除程序沙盒文件
+ (BOOL) deletePropertyFile:(NSString *) filePath
{
    BOOL isResult = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        isResult = [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }else {
        isResult = YES;
    }
    return isResult;
}


@end
