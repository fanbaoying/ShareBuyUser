//
//  MarxBannerViewPage.h
//  CloudCampus
//
//  Created by Marx on 16/2/28.
//  Copyright © 2016年 Marx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MarxBannerViewPage;

@protocol MarxBannerViewPageDelegate <NSObject>

- (void)didSelectedMarxBannerViewPage:(MarxBannerViewPage *)bannerViewPage;

@end

typedef NS_ENUM(NSInteger, MarxBannerViewPageStyle){
    MarxBannerViewStyleNormal
};

@interface MarxBannerViewPage : UIView

@property(nonatomic,weak)id<MarxBannerViewPageDelegate>delegate;

@property(nonatomic,strong)NSString *reuseIdentifier;

@property(nonatomic)NSString *title;
@property(nonatomic)UILabel *titleLabel;

- (instancetype)initWithStyle:(MarxBannerViewPageStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
