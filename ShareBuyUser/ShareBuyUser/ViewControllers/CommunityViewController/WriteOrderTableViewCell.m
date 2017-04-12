//
//  WriteOrderTableViewCell.m
//  ShareBuyUser
//
//  Created by 刘兵 on 16/8/10.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "WriteOrderTableViewCell.h"

@implementation WriteOrderTableViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _img = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 75, 75)];
    _img.backgroundColor = [UIColor redColor];
    [self addSubview:_img];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_img.frame)+10, CGRectGetMinY(_img.frame)+5, kScreenWidth - CGRectGetMaxX(_img.frame)-20, 15)];
    _nameLabel.font = UIFontPingFangMedium(14);
    _nameLabel.text = @"RIO 的金发科技卡罗积分大酒店附近";
    [self addSubview:_nameLabel];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectOffset(_nameLabel.frame, 0, 28)];
    _priceLabel.font = UIFontPingFangMedium(14);
    _priceLabel.textColor = UIColorFromHex(0xff5f3b, 1);
    _priceLabel.text = @"¥68";
    [self addSubview:_priceLabel];
    
    _numLabel = [[UILabel alloc] initWithFrame:CGRectOffset(_priceLabel.frame, 0, 28)];
    _numLabel.font = UIFontPingFangMedium(14);
    _numLabel.text = @"x2";
    [self addSubview:_numLabel];
    
    return self;
}

- (void)setModel:(NSDictionary *)model {
    _model = model;
}

@end
