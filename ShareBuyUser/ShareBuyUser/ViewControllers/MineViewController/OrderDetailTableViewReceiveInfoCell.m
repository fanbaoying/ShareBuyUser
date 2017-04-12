//
//  OrderDetailTableViewReceiveInfoCell.m
//  ShareBuyUser
//
//  Created by Marx on 16/8/10.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "OrderDetailTableViewReceiveInfoCell.h"

@implementation OrderDetailTableViewReceiveInfoCell

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
    [self addSubview:self.nameLabel];
    [self addSubview:self.phoneLabel];
    UIView *lineView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 44.75, kScreenWidth-20, 0.5)];
        [view setBackgroundColor:UIColorFromHex(0xbbbbbb, 1)];
        view;
    });
    [self addSubview:lineView];
    
    UILabel *addressLabel = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 40, 35)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextAlignment:NSTextAlignmentLeft];
        [label setTextColor:UIColorFromHex(0x696969, 1)];
        [label setFont:UIFontPingFangRegular(13)];
        [label setText:@"地址："];
        label;
    });
    [self addSubview:addressLabel];
    
    [self addSubview:self.addressLabel];
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, kScreenWidth/2-10, 35)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextAlignment:NSTextAlignmentLeft];
            [label setTextColor:UIColorFromHex(0x999999, 1)];
            [label setFont:UIFontPingFangRegular(13)];
            label;
        });
    }
    return _nameLabel;
}

- (UILabel *)phoneLabel
{
    if (!_phoneLabel) {
        _phoneLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2, 5, kScreenWidth/2 - 10, 35)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextAlignment:NSTextAlignmentRight];
            [label setTextColor:UIColorFromHex(0x999999, 1)];
            [label setFont:UIFontPingFangRegular(13)];
            label;
        });
    }
    return _phoneLabel;
}

- (UILabel *)addressLabel
{
    if (!_addressLabel) {
        _addressLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, kScreenWidth -60, 35)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextAlignment:NSTextAlignmentRight];
            [label setTextColor:UIColorFromHex(0x999999, 1)];
            [label setFont:UIFontPingFangRegular(13)];
            label;
        });
    }
    return _addressLabel;
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
