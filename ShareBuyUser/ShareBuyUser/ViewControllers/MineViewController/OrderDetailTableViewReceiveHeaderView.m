//
//  OrderDetailTableViewReceiveHeaderView.m
//  ShareBuyUser
//
//  Created by Marx on 16/8/10.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "OrderDetailTableViewReceiveHeaderView.h"

@implementation OrderDetailTableViewReceiveHeaderView

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
    
    UIView *colorView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 5, 3, 20)];
        [view setBackgroundColor:kMainColor];
        view;
    });
    
    [self addSubview:colorView];
    
    UILabel *titleLabel = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 100, 20)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:kMainColor];
        [label setFont:UIFontPingFangRegular(13)];
        [label setText:@"收货信息"];
        label;
    });
    
    [self addSubview:titleLabel];
}


@end
