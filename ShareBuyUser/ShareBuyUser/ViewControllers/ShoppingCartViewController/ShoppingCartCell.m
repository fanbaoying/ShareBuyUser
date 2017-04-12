
//
//  ShoppingCartCell.m
//  ShareBuyUser
//
//  Created by soldier on 16/8/9.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "ShoppingCartCell.h"

@implementation ShoppingCartCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        _checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkButton setFrame:CGRectMake(10, 40, 25, 25)];
        [_checkButton setImage:[UIImage imageNamed:@"check_normal"] forState:UIControlStateNormal];
        [_checkButton setImage:[UIImage imageNamed:@"check_select"] forState:UIControlStateSelected];
        [_checkButton addTarget:self action:@selector(clickCheckBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_checkButton];
        
        _productImgView = [[UIImageView alloc] initWithFrame:CGRectMake(45, 15, 90, 90)];
        [_productImgView setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"product_placeholder"]];
        [self addSubview:_productImgView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 15, kScreenWidth-160, 50)];
        [_nameLabel setText:@"红玫瑰红玫瑰红玫瑰红玫瑰红玫瑰红玫瑰红玫瑰红玫瑰红玫瑰"];
        [_nameLabel setFont:UIFontPingFangMedium(14.0f)];
        [_nameLabel setNumberOfLines:0];
        [_nameLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [self addSubview:_nameLabel];
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 70, kScreenWidth-160, 20)];
        [_priceLabel setText:@"￥128.00"];
        [_priceLabel setTextColor:kMainColor];
        [_priceLabel setFont:UIFontPingFangMedium(14.0f)];
        [self addSubview:_priceLabel];
        
        UIView *numberView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth-100, 80, 90, 25)];
        [numberView setBackgroundColor:[UIColor whiteColor]];
        numberView.layer.borderColor = [UIColorFromHex(0x999999, 1) CGColor];
        numberView.layer.borderWidth = 0.5f;
        numberView.layer.masksToBounds = YES;
        numberView.layer.cornerRadius = 4.0f;
        [self addSubview:numberView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(25, 0, 0.5, 25)];
        [lineView setBackgroundColor:UIColorFromHex(0x999999, 1)];
        [numberView addSubview:lineView];
        
        lineView = [[UIView alloc] initWithFrame:CGRectMake(65, 0, 0.5, 25)];
        [lineView setBackgroundColor:UIColorFromHex(0x999999, 1)];
        [numberView addSubview:lineView];
        
        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 40, 25)];
        [_numLabel setBackgroundColor:[UIColor clearColor]];
        [_numLabel setText:@"1"];
        [_numLabel setTextAlignment:NSTextAlignmentCenter];
        [_numLabel setFont:UIFontPingFangMedium(14.0f)];
        [numberView addSubview:_numLabel];
        
        _minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_minusButton setBackgroundColor:[UIColor clearColor]];
        [_minusButton setFrame:CGRectMake(0, 0, 25, 25)];
        [_minusButton setTitle:@"-" forState:UIControlStateNormal];
        _minusButton.titleLabel.font = UIFontPingFangMedium(15.0f);
        [_minusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_minusButton addTarget:self action:@selector(clickMinusBtn:) forControlEvents:UIControlEventTouchUpInside];
        [numberView addSubview:_minusButton];
        
        _plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_plusButton setBackgroundColor:[UIColor clearColor]];
        [_plusButton setFrame:CGRectMake(65, 0, 25, 25)];
        [_plusButton setTitle:@"+" forState:UIControlStateNormal];
        [_plusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _plusButton.titleLabel.font = UIFontPingFangMedium(15.0f);
        [_plusButton addTarget:self action:@selector(clickPlusBtn:) forControlEvents:UIControlEventTouchUpInside];
        [numberView addSubview:_plusButton];
    }
    return self;
}

- (void)clickMinusBtn:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(shoppingCartMinusBtn:)]) {
        [_delegate shoppingCartMinusBtn:self];
    }
}

- (void)clickPlusBtn:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(shoppingCartPlusBtn:)]) {
        [_delegate shoppingCartPlusBtn:self];
    }
}

- (void)clickCheckBtn:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(shoppingCartCheckBtn:)]) {
        [_delegate shoppingCartCheckBtn:self];
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
