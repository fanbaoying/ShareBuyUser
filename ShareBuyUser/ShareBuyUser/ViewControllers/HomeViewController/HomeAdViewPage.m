//
//  HomeAdViewPage.m
//  ShareBuyUser
//
//  Created by soldier on 16/8/9.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "HomeAdViewPage.h"

@implementation HomeAdViewPage

- (id)initWithStyle:(MarxBannerViewPageStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _adImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
        [_adImageView setClipsToBounds:YES];
        [_adImageView setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:_adImageView];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
