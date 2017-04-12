//
//  HomeCollectionViewCell.m
//  ShareBuyUser
//
//  Created by soldier on 16/8/8.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "HomeCollectionViewCell.h"

@implementation HomeCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    [self setBackgroundColor:[UIColor whiteColor]];
//    self.layer.masksToBounds = YES;
//    self.layer.cornerRadius = 3.0f;
    
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
    [_imgView setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"product_placeholder"]];
    [self addSubview:_imgView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.width, self.frame.size.width, 20)];
    [_titleLabel setText:@"夏天自营制品"];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleLabel setTextColor:UIColorFromHex(0x3c3c3c, 1)];
    [_titleLabel setFont:UIFontPingFangRegular(14.0f)];
    [self addSubview:_titleLabel];
    
    _subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.width+20, self.frame.size.width, 20)];
    [_subTitleLabel setText:@"188减88"];
    [_subTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [_subTitleLabel setTextColor:UIColorFromHex(0x696969, 1)];
    [_subTitleLabel setFont:UIFontPingFangMedium(12.0f)];
    [self addSubview:_subTitleLabel];
    
    _locationImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.frame.size.width+25, 11, 14)];
    [_locationImgView setImage:[UIImage imageNamed:@"home_location"]];
    [_locationImgView setHidden:YES];
    [self addSubview:_locationImgView];
    
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
