//
//  AdReusableView.h
//  ShareBuyUser
//
//  Created by soldier on 16/8/9.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Color.h"
#import "MarxBannerView.h"
#import "HomeAdViewPage.h"

@class AdReusableView;
@protocol AdReusableDelegete <NSObject>

- (void)selectHomeAdReusableView:(AdReusableView *)view andPage:(NSInteger)page;

@end

@interface AdReusableView : UICollectionReusableView <MarxBannerViewDataSource,MarxBannerViewDelegate>

@property (nonatomic, strong) MarxBannerView *bannerView;
@property (nonatomic, strong) NSArray *adArray;
@property (nonatomic, assign) id<AdReusableDelegete>delegate;


@end
