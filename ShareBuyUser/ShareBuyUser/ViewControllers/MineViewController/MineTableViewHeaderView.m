//
//  MineTableViewHeaderView.m
//  ShareBuyUser
//
//  Created by Marx on 16/8/9.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "MineTableViewHeaderView.h"

@implementation MineTableViewHeaderView

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
    [self addSubview:self.bgImageView];
}

- (UIImageView *)bgImageView
{
    if (!_bgImageView) {
        _bgImageView = ({
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200*kWR)];
            [imageView setUserInteractionEnabled:YES];
            [imageView setImage:[UIImage imageNamed:@"mine_header_bg_image"]];
            
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImgView)];
            [imageView addGestureRecognizer:recognizer];
            
            UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(kScreenWidth/2, 100*kWR) radius:36.5 startAngle:-0.5*M_PI endAngle:1.5*M_PI clockwise:YES];
            
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            
            shapeLayer.path = path.CGPath;
            shapeLayer.strokeColor = UIColorFromHex(0xffffff, 0.3).CGColor;
            shapeLayer.fillColor = [UIColor clearColor].CGColor;
            shapeLayer.strokeStart = 0;
            shapeLayer.strokeEnd = 1;
            shapeLayer.lineWidth = 3;
            
            [imageView.layer addSublayer:shapeLayer];
            
            [imageView addSubview:self.userAvatarImageView];
            [imageView addSubview:self.loginButton];
            [imageView addSubview:self.nickLabel];
            
            imageView;
        });
    }
    
    return _bgImageView;
}

- (UIImageView *)userAvatarImageView
{
    if (!_userAvatarImageView) {
        _userAvatarImageView = ({
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-70)/2, (200*kWR-70)/2, 70, 70)];
            imageView.layer.masksToBounds = YES;
            imageView.layer.cornerRadius = 35.0f;
            [imageView setImageWithURL:[NSURL URLWithString:[UserModel shareUserModel].userAvatar] placeholderImage:[UIImage imageNamed:@"mine_avatar_placeholder_image"]];
            imageView;
        });
    }
    return _userAvatarImageView;
}

- (UIButton *)loginButton
{
    if (!_loginButton) {
        _loginButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake((kScreenWidth - 100)/2, 100*kWR +50, 100, 40)];
            [button setBackgroundColor:[UIColor clearColor]];
            [button setTitle:@"登录" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button.titleLabel setFont:UIFontPingFangRegular(17)];
            [button setShowsTouchWhenHighlighted:YES];
            [button addTarget:self action:@selector(selectLoginButton:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    
    return _loginButton;
}

- (UILabel *)nickLabel
{
    if (!_nickLabel) {
        _nickLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 100)/2, 100*kWR +50, 100, 40)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextColor:[UIColor whiteColor]];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setFont:UIFontPingFangRegular(15)];
            label;
        });
    }
    return _nickLabel;
}

- (IBAction)selectLoginButton:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(selectLoginButtonWithMineTableViewHeader:)]) {
        [self.delegate selectLoginButtonWithMineTableViewHeader:self];
    }
}

- (void)clickImgView
{
    if ([_delegate respondsToSelector:@selector(selectPersonalInfo)]) {
        [_delegate selectPersonalInfo];
    }
}


@end
