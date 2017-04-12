//
//  ShopCollectionViewCell.m
//  ShareBuyUser
//
//  Created by soldier on 16/8/9.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "ShopCollectionViewCell.h"

@implementation ShopCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    [self setBackgroundColor:[UIColor whiteColor]];
    //    self.layer.masksToBounds = YES;
    //    self.layer.cornerRadius = 3.0f;
    
    _shopImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
    [_shopImgView setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"product_placeholder"]];
    [self addSubview:_shopImgView];
    
    _shopTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.frame.size.width+3, self.frame.size.width-10, 20)];
    [_shopTitleLabel setText:@"沃尔玛（三义街店）"];
    [_shopTitleLabel setTextColor:UIColorFromHex(0x3c3c3c, 1)];
    [_shopTitleLabel setFont:UIFontPingFangRegular(14.0f)];
    [self addSubview:_shopTitleLabel];
    
    _locationImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.frame.size.width+23, 11, 14)];
    [_locationImgView setImage:[UIImage imageNamed:@"home_location"]];
    [_locationImgView setHidden:NO];
    [self addSubview:_locationImgView];
    
    _shopAddLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, self.frame.size.width+25, self.frame.size.width-30, 15)];
    [_shopAddLabel setText:@"188减88"];
//    [_shopAddLabel setTextAlignment:NSTextAlignmentCenter];
    [_shopAddLabel setTextColor:UIColorFromHex(0x696969, 1)];
    [_shopAddLabel setFont:UIFontPingFangMedium(12.0f)];
    [self addSubview:_shopAddLabel];
    
    return self;
}

@end
