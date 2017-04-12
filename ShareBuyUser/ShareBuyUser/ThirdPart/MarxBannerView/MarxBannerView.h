//
//  MarxBannerView.h
//  CloudCampus
//
//  Created by Marx on 16/2/28.
//  Copyright © 2016年 Marx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarxBannerViewPage.h"

@class MarxBannerView;


@protocol MarxBannerViewDataSource <NSObject>

@required
- (NSInteger)numberOfPageInBannerView:(MarxBannerView *)banner;
- (MarxBannerViewPage *)marxBannerView:(MarxBannerView *)bannerView pageForPage:(NSInteger)page;
@optional
- (CGRect)frameForPageControlInMarxBannerView:(MarxBannerView *)bannerView;
@end

@protocol MarxBannerViewDelegate <NSObject>

@optional
- (void)marxBannerView:(MarxBannerView *)bannerView didSelectPage:(NSInteger)page;
- (void)marxBannerView:(MarxBannerView *)bannerView didScrollToPage:(NSInteger)page;
@end

@interface MarxBannerView : UIView

@property(nonatomic,weak) id<MarxBannerViewDataSource> datasource;
@property(nonatomic,weak) id<MarxBannerViewDelegate> delegate;

@property(nonatomic,assign,getter=isContinuity) BOOL continuity;
@property(nonatomic,strong)UIPageControl *pageControl;



- (void)reloadData;

- (MarxBannerViewPage *)dequeueReusablePageWithIdentifier:(NSString *)identifier;

@end
