//
//  StoreDetailCell.m
//  ShareBuyUser
//
//  Created by soldier on 16/8/10.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "StoreDetailCell.h"

@implementation StoreDetailCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(3, 5, kScreenWidth-6, 70)];
        [bgView setBackgroundColor:[UIColor whiteColor]];
        bgView.layer.masksToBounds = YES;
        bgView.layer.cornerRadius = 3.0f;
        [self addSubview:bgView];
        
        _categoryNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bgView.frame.size.width, 70)];
        [_categoryNameLabel setTextAlignment:NSTextAlignmentCenter];
        [_categoryNameLabel setTextColor:kMainColor];
        [_categoryNameLabel setFont:UIFontPingFangMedium(20.0f)];
        [bgView addSubview:_categoryNameLabel];
        
    }
    return self;
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
