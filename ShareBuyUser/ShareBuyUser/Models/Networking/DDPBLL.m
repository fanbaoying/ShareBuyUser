//
//  DDPBLL.m
//  ShareBuyUser
//
//  Created by soldier on 16/8/8.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "DDPBLL.h"

@implementation DDPBLL

+ (NSURLSessionDataTask *)requestWithURL:(NSString *)url Dict:(NSDictionary *)dict result:(void (^)(NSDictionary *responseDict))block
{
    return
    [[AFClient sharedClient]
     POST:url
     parameters:dict
     progress:^(NSProgress * _Nonnull uploadProgress) {
         NSLog(@"");
     }
     success:^(NSURLSessionDataTask *operation, id responseObject)
     {
         NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSLog(@"success  %@\n%@", url, string);
         
         //         NSDictionary *returnDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
         NSMutableDictionary *returnDict = [NSMutableDictionary dictionaryWithDictionary:[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil]];
         
         
         if (![returnDict[@"data"] isKindOfClass:[NSNull class]]) {
             if ([returnDict[@"data"] isKindOfClass:[NSArray class]]) {
                 NSMutableArray *resultArray = [NSMutableArray arrayWithArray:returnDict[@"data"]];
                 for (int m = 0; m<[resultArray count]; m++) {
                     NSMutableDictionary *resultDict1 = [NSMutableDictionary dictionaryWithDictionary:resultArray[m]];
                     for (NSString *key in [resultDict1 allKeys]) {
                         if ([resultDict1[key] isKindOfClass:[NSNull class]]) {
                             [resultDict1 setValue:@"" forKey:key];
                         }
                     }
                     [resultArray replaceObjectAtIndex:m withObject:resultDict1];
                 }
                 [returnDict setValue:resultArray forKey:@"data"];
             }else if ([returnDict[@"data"] isKindOfClass:[NSDictionary class]])
             {
                 NSMutableDictionary *resultDict = [NSMutableDictionary dictionaryWithDictionary:returnDict[@"data"]];
                 for (int i = 0; i<[[resultDict allKeys] count]; i++) {
                     if ([[resultDict allValues][i] isKindOfClass:[NSNull class]]) {
                         [resultDict setValue:@"" forKey:[resultDict allKeys][i]];
                     }
                 }
                 [returnDict setValue:resultDict forKey:@"data"];
             }
         }
         
         if (block)
         {
             block(returnDict);
         }
     }
     failure:^(NSURLSessionDataTask *operation, NSError *error)
     {
         //         NSLog(@"failure  %@\n%@", url, operation.responseString);
         
         NSLog(@"%ld", (long)error.code);
         NSLog(@"%@",error);
         
         //         if (error.code == kCFURLErrorNotConnectedToInternet) {DEF_OFFLINE_ERROR} else {DEF_SERVER_ERROR}
         if (error.code == kCFURLErrorNotConnectedToInternet) {
             [[UIApplication sharedApplication].keyWindow.rootViewController showHint:@"当前网络出现问题，请查看网络连接" yOffset:-250];
         }else
         {
             [[UIApplication sharedApplication].keyWindow.rootViewController showHint:@"无法连接服务器, 请稍后再试." yOffset:-250];
         }
         
         if (block)
         {
             block(nil);
         }
     }];
}

+ (NSURLSessionDataTask *)requestWithURL:(NSString *)url Dict:(NSDictionary *)dict andImage:(UIImage *)image andBlock:(void (^)(NSDictionary *))block
{
    return
    [[AFClient sharedClient] POST:url parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imgData;
        imgData = UIImageJPEGRepresentation(image, 0.4);
        [formData appendPartWithFileData:imgData name:@"headfile" fileName:@"avatar.png" mimeType:@"png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *returnDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSString *msg = returnDict[@"msg"];
        NSLog(@"%@",msg);
        
        NSString *code = [returnDict objectForKey:@"state"];
        if ([code integerValue] == 0) {
            if (block) {
                block(returnDict);
            }
        }else{
            if (block) {
                block(returnDict);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        if (block) {
            block(nil);
        }
    }];
}

@end
