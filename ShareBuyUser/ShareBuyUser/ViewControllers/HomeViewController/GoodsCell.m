//
//  GoodsCell.m
//  ShareBuyUser
//
//  Created by soldier on 16/8/10.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "GoodsCell.h"

@implementation GoodsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 3, kScreenWidth, 84)];
        [bgView setBackgroundColor:[UIColor whiteColor]];
        bgView.layer.masksToBounds = YES;
        bgView.layer.cornerRadius = 3.0f;
        [self addSubview:bgView];
        
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 74, 74)];
        [_imgView setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"product_placeholder"]];
        [bgView addSubview:_imgView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 5, kScreenWidth-95, 45)];
        [_nameLabel setText:@"康师傅蛋酥卷想弄奶油味384g"];
        [_nameLabel setTextColor:UIColorFromHex(0x3c3c3c, 1)];
        [_nameLabel setFont:UIFontPingFangMedium(15.0f)];
        [_nameLabel setNumberOfLines:0];
        [_nameLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [bgView addSubview:_nameLabel];
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 55, kScreenWidth-95, 20)];
        [_priceLabel setText:@"￥54.00"];
        [_priceLabel setTextColor:kMainColor];
        [_priceLabel setFont:UIFontPingFangMedium(15.0f)];
        [bgView addSubview:_priceLabel];
        
        _minusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_minusBtn setFrame:CGRectMake(kScreenWidth-100, 50, 30, 30)];
        [_minusBtn setBackgroundColor:[UIColor redColor]];
        [_minusBtn setTitle:@"-" forState:UIControlStateNormal];
        [_minusBtn addTarget:self action:@selector(clickMinusBtn:) forControlEvents:UIControlEventTouchUpInside];
//        [bgView addSubview:_minusBtn];
        
        _plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_plusBtn setFrame:CGRectMake(kScreenWidth-60, 50, 30, 30)];
        [_plusBtn setBackgroundColor:[UIColor greenColor]];
        [_plusBtn setTitle:@"+" forState:UIControlStateNormal];
        [_plusBtn addTarget:self action:@selector(clickPlusBtn:) forControlEvents:UIControlEventTouchUpInside];
//        [bgView addSubview:_plusBtn];
        
    }
    return self;
}

- (void)clickMinusBtn:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(numberMinus:)]) {
        [_delegate numberMinus:self];
    }
}

- (void)clickPlusBtn:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(numberPlus:)]) {
        [_delegate numberPlus:self];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
