//
//  OrderTableViewFooterView.m
//  ShareBuyUser
//
//  Created by Marx on 16/8/10.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "OrderTableViewFooterView.h"

@implementation OrderTableViewFooterView

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
    
    [self addSubview:self.orderInfoLabel];
    [self addSubview:self.payButton];
    [self addSubview:self.cancelButton];
    [self addSubview:self.confirmButton];
    [self addSubview:self.commentButton];
    [self addSubview:self.refundButton];
}

- (UILabel *)orderInfoLabel
{
    if (!_orderInfoLabel) {
        _orderInfoLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth-20, 20)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setTextColor:kMainColor];
            [label setFont:UIFontPingFangRegular(13)];
            label;
        });
    }
    return _orderInfoLabel;
}

- (UIButton *)payButton
{
    if (!_payButton) {
        _payButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTag:100];
            [button setFrame:CGRectMake(kScreenWidth - 185, 30, 80, 25)];
            [button.layer setMasksToBounds:YES];
            [button.layer setCornerRadius:5];
            [button setBackgroundImage:[UIImage imageWithColor:kMainColor size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
            [button setTitle:@"去付款" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button.titleLabel setFont:UIFontPingFangRegular(13)];
            [button addTarget:self action:@selector(selectFooterButton:) forControlEvents:UIControlEventTouchUpInside];
            
            button;
        });
    }
    return _payButton;
}

- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTag:101];
            [button setFrame:CGRectMake(kScreenWidth - 90, 30, 80, 25)];
            [button.layer setMasksToBounds:YES];
            [button.layer setCornerRadius:5];
            [button.layer setBorderColor:kMainColor.CGColor];
            [button.layer setBorderWidth:1];
            [button setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(0xff9881, 1) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
            [button setTitle:@"取消订单" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button.titleLabel setFont:UIFontPingFangRegular(13)];
            [button addTarget:self action:@selector(selectFooterButton:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _cancelButton;
}

- (UIButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTag:102];
            [button setFrame:CGRectMake(kScreenWidth - 90, 30, 80, 25)];
            [button.layer setMasksToBounds:YES];
            [button.layer setCornerRadius:5];
            [button setBackgroundImage:[UIImage imageWithColor:kMainColor size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
            [button setTitle:@"确认收货" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button.titleLabel setFont:UIFontPingFangRegular(13)];
            [button addTarget:self action:@selector(selectFooterButton:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _confirmButton;
}

- (UIButton *)commentButton
{
    if (!_commentButton) {
        _commentButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTag:103];
            [button setFrame:CGRectMake(kScreenWidth - 185, 30, 80, 25)];
            [button.layer setMasksToBounds:YES];
            [button.layer setCornerRadius:5];
            [button setBackgroundImage:[UIImage imageWithColor:kMainColor size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
            [button setTitle:@"去评价" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button.titleLabel setFont:UIFontPingFangRegular(13)];
            [button addTarget:self action:@selector(selectFooterButton:) forControlEvents:UIControlEventTouchUpInside];
            
            button;
        });
    }
    return _commentButton;
}

- (UIButton *)refundButton
{
    if (!_refundButton) {
        _refundButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTag:104];
            [button setFrame:CGRectMake(kScreenWidth - 90, 30, 80, 25)];
            [button.layer setMasksToBounds:YES];
            [button.layer setCornerRadius:5];
            [button.layer setBorderColor:kMainColor.CGColor];
            [button.layer setBorderWidth:1];
            [button setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(0xff9881, 1) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
            [button setTitle:@"售后/退款" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button.titleLabel setFont:UIFontPingFangRegular(13)];
            [button addTarget:self action:@selector(selectFooterButton:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _refundButton;
}

- (IBAction)selectFooterButton:(UIButton *)sender
{
    switch (sender.tag - 100) {
        case 0:
            //支付
            if ([self.delegate respondsToSelector:@selector(selectFooterViewPayButtonWithSection:)]) {
                [self.delegate selectFooterViewPayButtonWithSection:_section];
            }
            break;
        case 1:
            //取消
            if ([self.delegate respondsToSelector:@selector(selectFooterViewCancelButtonWithSection:)]) {
                [self.delegate selectFooterViewCancelButtonWithSection:_section];
            }
            break;
        case 2:
            //确认
            if ([self.delegate respondsToSelector:@selector(selectFooterViewConfirmButtonWithSection:)]) {
                [self.delegate selectFooterViewConfirmButtonWithSection:_section];
            }
            break;
        case 3:
            //评论
            if ([self.delegate respondsToSelector:@selector(selectFooterViewCommentButtonWithSection:)]) {
                [self.delegate selectFooterViewCommentButtonWithSection:_section];
            }
            break;
        case 4:
            //售后
            if ([self.delegate respondsToSelector:@selector(selectFooterViewRefundButtonWithSection:)]) {
                [self.delegate selectFooterViewRefundButtonWithSection:_section];
            }
            break;
            
            
        default:
            break;
    }
}



@end
