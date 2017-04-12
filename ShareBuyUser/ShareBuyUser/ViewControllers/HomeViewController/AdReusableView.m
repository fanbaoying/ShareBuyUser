//
//  AdReusableView.m
//  ShareBuyUser
//
//  Created by soldier on 16/8/9.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "AdReusableView.h"

@implementation AdReusableView

- (id)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.bannerView];

    return self;

}

- (MarxBannerView *)bannerView
{
    if (!_bannerView) {
        _bannerView = ({
            MarxBannerView *bannerView = [[MarxBannerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
            [bannerView setDatasource:self];
            [bannerView setDelegate:self];
            [bannerView.pageControl setCurrentPageIndicatorTintColor:UIColorFromHex(0xffffff, 1)];
            [bannerView.pageControl setPageIndicatorTintColor:UIColorFromHex(0xffffff, 0.5)];
            bannerView;
        });
    }
    return _bannerView;
}

#pragma mark MarxBannerViewDataSource
- (NSInteger)numberOfPageInBannerView:(MarxBannerView *)banner
{
    return [_adArray count];
}

- (MarxBannerViewPage *)marxBannerView:(MarxBannerView *)bannerView pageForPage:(NSInteger)page
{
    static NSString *pageID = @"PageID";
    HomeAdViewPage *adViewPage = (HomeAdViewPage *)[bannerView dequeueReusablePageWithIdentifier:pageID];
    if (!adViewPage) {
        adViewPage = [[HomeAdViewPage alloc] initWithStyle:MarxBannerViewStyleNormal reuseIdentifier:pageID];
        //        [adViewPage setDelegate:self];
    }
    [adViewPage.adImageView setImageWithURL:[NSURL URLWithString:_adArray[page]] placeholderImage:[UIImage imageNamed:@"product_placeholder"]];
//    [adViewPage.adImageView setImage:[UIImage imageNamed:_adArray[page]]];

    
    return adViewPage;
}

- (CGRect)frameForPageControlInMarxBannerView:(MarxBannerView *)bannerView
{
    return CGRectMake((kScreenWidth-10*[_adArray count])/2, 160, 10*[_adArray count], 20);
}

- (void)marxBannerView:(MarxBannerView *)bannerView didSelectPage:(NSInteger)page
{
    //    NSLog(@"%ld",(long)page);
    [_delegate selectHomeAdReusableView:self andPage:page];
}


@end
