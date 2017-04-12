//
//  TitleHeadReusableView.m
//  ShareBuyUser
//
//  Created by soldier on 16/8/9.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "TitleHeadReusableView.h"

@implementation TitleHeadReusableView

- (id)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    self.backgroundColor = [UIColor clearColor];
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 3, 3, 25)];
    [lineView setBackgroundColor:kMainColor];
    [self addSubview:lineView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 30)];
    [_titleLabel setText:@"热门店铺"];
    [_titleLabel setTextColor:kMainColor];
    [_titleLabel setFont:UIFontPingFangMedium(16.0f)];
    [self addSubview:_titleLabel];
    
    _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_moreButton setFrame:CGRectMake(kScreenWidth - 50, 0, 40, 30)];
    [_moreButton setTitle:@"更多" forState:UIControlStateNormal];
    [_moreButton setTitleColor:UIColorFromHex(0x696969, 1) forState:UIControlStateNormal];
    _moreButton.titleLabel.font = UIFontPingFangMedium(13.0f);
    [_moreButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    [_moreButton setImage:[UIImage imageNamed:@"home_more_arrow"] forState:UIControlStateNormal];
    [_moreButton setImageEdgeInsets:UIEdgeInsetsMake(0, 25, 0, -25)];
    [_moreButton addTarget:self action:@selector(clickMoreButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_moreButton];
    
    return self;
}

- (void)clickMoreButton:(UIButton *)sender
{
    if (![_delegate respondsToSelector:@selector(clickMoreButton:)]) {
        [_delegate clickTitleHeadMoreButton:sender];
    }
}



@end
