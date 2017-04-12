//
//  NoDataView.m
//  ShareBuyUser
//
//  Created by soldier on 16/8/8.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "NoDataView.h"

@implementation NoDataView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:UIColorFromHex(0xf5f5f5, 1)];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-90)/2, 100, 90, 90)];
        [_imageView setImage:[UIImage imageNamed:@"no_address"]];
        [self addSubview:_imageView];
        
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, kScreenWidth, 20)];
        [_messageLabel setText:@"抱歉，当前地址暂未开通服务，敬请期待"];
        [_messageLabel setTextColor:UIColorFromHex(0x686868, 1)];
        [_messageLabel setTextAlignment:NSTextAlignmentCenter];
        [_messageLabel setFont:[UIFont systemFontOfSize:13.0f]];
        [self addSubview:_messageLabel];
        
        _functionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_functionButton setFrame:CGRectMake((kScreenWidth-150)/2, 235, 150, 30)];
        _functionButton.layer.borderColor = [UIColorFromHex(0xd6d6d6, 1) CGColor];
        _functionButton.layer.borderWidth = 0.5f;
        _functionButton.layer.masksToBounds = YES;
        _functionButton.layer.cornerRadius = 3.0f;
        [_functionButton setTitle:@"刷新重试" forState:UIControlStateNormal];
        [_functionButton.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
        [_functionButton setTitleColor:UIColorFromHex(0x686868, 1) forState:UIControlStateNormal];
        [_functionButton addTarget:self action:@selector(clickRefreshBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_functionButton];
    }
    return self;
}

- (void)setMessage:(NSString *)message AndTitle:(NSString *)title AndImage:(UIImage *)image
{
    [_messageLabel setText:message];
    [_functionButton setTitle:title forState:UIControlStateNormal];
    [_imageView setImage:image];
}

- (void)clickRefreshBtn
{
    if ([_delegate respondsToSelector:@selector(refreshNetworking)]) {
        [_delegate refreshNetworking];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
