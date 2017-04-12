//
//  BaseWebViewController.h
//  ShareBuyUser
//
//  Created by soldier on 16/8/18.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "BaseViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface BaseWebViewController : BaseViewController <UIWebViewDelegate>

@property (nonatomic, strong) NSString *htmlString;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSString *webUrlStr;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIBarButtonItem *shareBarBtnItem;

@property (nonatomic, strong) NSString *goodsId;
@property (nonatomic, strong) NSMutableDictionary *goodsDic;

@end
