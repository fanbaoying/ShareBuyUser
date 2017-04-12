//
//  OrderTableViewGoodCell.m
//  ShareBuyUser
//
//  Created by Marx on 16/8/10.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "OrderTableViewGoodCell.h"

@implementation OrderTableViewGoodCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self customView];
    }
    return self;
}

#pragma mark Custom View
- (void)customView
{
    [self addSubview:self.goodImageView];
    [self addSubview:self.goodNameLabel];
    [self addSubview:self.goodPriceLabel];
    [self addSubview:self.goodNumLabel];
    [self addSubview:self.lineView];
}

- (UIImageView *)goodImageView
{
    if (!_goodImageView) {
        _goodImageView = ({
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 70, 70)];
            [imageView setBackgroundColor:[UIColor clearColor]];
            [imageView setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"product_placeholder"]];
            imageView;
        });
    }
    return _goodImageView;
}

- (UILabel *)goodNameLabel
{
    if (!_goodNameLabel) {
        _goodNameLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, kScreenWidth -100, 30)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextAlignment:NSTextAlignmentLeft];
            [label setTextColor:UIColorFromHex(0x696969, 1)];
            [label setFont:UIFontPingFangRegular(13)];
            
            label;
        });
    }
    return _goodNameLabel;
}

- (UILabel *)goodPriceLabel
{
    if (!_goodPriceLabel) {
        _goodPriceLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(90, 40, kScreenWidth-100, 20)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextAlignment:NSTextAlignmentLeft];
            [label setTextColor:kMainColor];
            [label setFont:UIFontPingFangRegular(13)];
            
            label;
        });
    }
    return _goodPriceLabel;
}

- (UILabel *)goodNumLabel
{
    if (!_goodNumLabel) {
        _goodNumLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(90, 60, kScreenWidth-100, 20)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextAlignment:NSTextAlignmentLeft];
            [label setTextColor:UIColorFromHex(0x999999, 1)];
            [label setFont:UIFontPingFangRegular(13)];
            
            label;
        });
    }
    return _goodNumLabel;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 89.5, kScreenWidth-20, 0.5)];
            [view setBackgroundColor:UIColorFromHex(0xbbbbbb, 1)];
            view;
        });
    }
    return _lineView;
}

- (void)setDic:(NSDictionary *)dic
{
    _dic = dic;
    [_goodImageView setImageWithURL:[NSURL URLWithString:_dic[@"imgurl"]] placeholderImage:[UIImage imageNamed:@"product_placeholder"]];
    [_goodNameLabel setText:_dic[@"goodsname"]];
    [_goodNumLabel setText:[NSString stringWithFormat:@"%@",_dic[@"num"]]];
    [_goodPriceLabel setText:[NSString stringWithFormat:@"¥%.2f",[_dic[@"onprice"] floatValue]]];
    
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
