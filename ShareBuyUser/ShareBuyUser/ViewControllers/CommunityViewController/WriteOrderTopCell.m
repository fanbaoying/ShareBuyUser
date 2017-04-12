//
//  WriteOrderTopCell.m
//  ShareBuyUser
//
//  Created by 刘兵 on 16/8/10.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "WriteOrderTopCell.h"

@implementation WriteOrderTopCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60, 50)];
    label1.text = @"收货人：";
    label1.font = UIFontPingFangMedium(14);
    [self addSubview:label1];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame), 0, 70, 50)];
    _nameLabel.font = UIFontPingFangMedium(14);
    _nameLabel.text = @"张三";
    _nameLabel.textColor = UIColorFromHex(0x5d5d5d, 1);
    [self addSubview:_nameLabel];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_nameLabel.frame), 0, 80, 50)];
    label2.text = @"联系电话：";
    label2.font = UIFontPingFangMedium(14);
    [self addSubview:label2];
    
    _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label2.frame), 0, kScreenWidth - CGRectGetMaxX(label2.frame), 50)];
    _phoneLabel.text = @"18802456377";
    _phoneLabel.font = UIFontPingFangMedium(14);
    _phoneLabel.textColor = UIColorFromHex(0x5d5d5d, 1);
    [self addSubview:_phoneLabel];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(label1.frame), 50, 50)];
    label3.text = @"地址:";
    label3.font = UIFontPingFangMedium(14);
    [self addSubview:label3];
    
    _addrLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label3.frame), CGRectGetMinY(label3.frame), kScreenWidth - CGRectGetMaxX(label3.frame), 50)];
    _addrLabel.text = @"辽宁省沈阳市浑南新区沈阳国际软件园";
    _addrLabel.font = UIFontPingFangMedium(14);
    _addrLabel.textColor = UIColorFromHex(0x5d5d5d, 1);
    [self addSubview:_addrLabel];
    
    return self;
}

- (void)setModel:(NSDictionary *)model {
    _model = model;
    
    [_nameLabel setText:_model[@"name"]];
    [_phoneLabel setText:_model[@"phone"]];
    [_addrLabel setText:_model[@"address"]];
}

@end
