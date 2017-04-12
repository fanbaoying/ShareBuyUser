//
//  HotCityCell.m
//  ShareBuyUser
//
//  Created by soldier on 16/8/17.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "HotCityCell.h"

@implementation HotCityCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setHotCityArray:(NSArray *)hotCityArray
{
    _hotCityArray = hotCityArray;
    for (int i = 0; i < [_hotCityArray count]; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTag:100+i];
        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:5];
        [button.layer setBorderColor:UIColorFromHex(0xf2f2f2, 1).CGColor];
        [button.layer setBorderWidth:1];
        [button setFrame:CGRectMake(15+80*i, 2.5, 50, 35)];
        [button.titleLabel setFont:UIFontPingFangRegular(13)];
        [button setTitleColor:UIColorFromHex(0x252525, 1) forState:UIControlStateNormal];
        [button setTitle:_hotCityArray[i][@"cname"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(selectCityButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

- (void)selectCityButton:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(hotCityCell:selectedButtonWithTag:)]) {
        [self.delegate hotCityCell:self selectedButtonWithTag:sender.tag];
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
