//
//  OrderDetailTableViewMerchantFooterView.m
//  ShareBuyUser
//
//  Created by Marx on 16/8/10.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "OrderDetailTableViewMerchantFooterView.h"

@implementation OrderDetailTableViewMerchantFooterView

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
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    UILabel *titleLabel = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 90, 0, 40, 20)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:UIColorFromHex(0x696969, 1)];
        [label setFont:UIFontPingFangRegular(13)];
        [label setText:@"快递:"];
        label;
    });
    [self addSubview:titleLabel];
    [self addSubview:self.expressNameLabel];
}

- (UILabel *)expressNameLabel
{
    if (!_expressNameLabel) {
        _expressNameLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 50, 0, 40, 20)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextColor:UIColorFromHex(0x999999, 1)];
            [label setFont:UIFontPingFangRegular(13)];
            label;
        });
    }
    return _expressNameLabel;
}

@end
