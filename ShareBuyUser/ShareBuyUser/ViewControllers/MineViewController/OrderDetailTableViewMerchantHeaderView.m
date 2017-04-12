//
//  OrderDetailTableViewMerchantHeaderView.m
//  ShareBuyUser
//
//  Created by Marx on 16/8/10.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "OrderDetailTableViewMerchantHeaderView.h"

@implementation OrderDetailTableViewMerchantHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self customView];
    }
    
    return self;
}

#pragma mark Custom View
- (void)customView
{
    [self.contentView setBackgroundColor:UIColorFromHex(0xf6f6f6, 1)];
    
    UIView *bgView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 30)];
        [view setBackgroundColor:[UIColor whiteColor]];
        view;
    });
    [self addSubview:bgView];
    
    [bgView addSubview:self.merchantNameLabel];
//    [bgView addSubview:self.statusLabel];
}

- (UILabel *)merchantNameLabel
{
    if (!_merchantNameLabel) {
        _merchantNameLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, kScreenWidth/2-10, 20)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextAlignment:NSTextAlignmentLeft];
            [label setTextColor:UIColorFromHex(0x696969, 1)];
            [label setFont:UIFontPingFangRegular(13)];
            
            label;
        });
    }
    
    return _merchantNameLabel;
}

@end
