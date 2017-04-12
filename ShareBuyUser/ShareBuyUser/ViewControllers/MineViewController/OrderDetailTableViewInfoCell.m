//
//  OrderDetailTableViewInfoCell.m
//  ShareBuyUser
//
//  Created by Marx on 16/8/10.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "OrderDetailTableViewInfoCell.h"

@implementation OrderDetailTableViewInfoCell

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
    [self addSubview:self.titleLabel];
    [self addSubview:self.valueLabel];
    [self addSubview:self.lineView];
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, kScreenWidth/2-10, 35)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextColor:UIColorFromHex(0x696969, 1)];
            [label setTextAlignment:NSTextAlignmentLeft];
            [label setFont:UIFontPingFangRegular(13)];
            
            label;
        });
    }
    return _titleLabel;
}

- (UILabel *)valueLabel
{
    if (!_valueLabel) {
        _valueLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2, 5, kScreenWidth/2-10, 35)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextColor:UIColorFromHex(0x999999, 1)];
            [label setTextAlignment:NSTextAlignmentRight];
            [label setFont:UIFontPingFangRegular(13)];
            
            label;
        });
    }
    return _valueLabel;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 44.5, kScreenWidth-20, 0.5)];
            [view setBackgroundColor:UIColorFromHex(0xbbbbbb, 1)];
            view;
        });
    }
    return _lineView;
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
