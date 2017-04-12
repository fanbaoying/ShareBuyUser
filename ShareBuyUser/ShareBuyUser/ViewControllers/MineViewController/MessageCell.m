//
//  MessageCell.m
//  ShareBuyUser
//
//  Created by soldier on 16/8/23.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, kScreenWidth, 65)];
        [bgView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:bgView];
        
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 45, 45)];
        _imgView.layer.masksToBounds = YES;
        _imgView.layer.cornerRadius = 22.5;
        [_imgView setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"product_placeholder"]];
        [bgView addSubview:_imgView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 10, kScreenWidth-75, 20)];
        [_titleLabel setText:@"系统消息"];
        [_titleLabel setFont:UIFontPingFangMedium(16.0f)];
        [bgView addSubview:_titleLabel];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 30, kScreenWidth-75, 30)];
        [_contentLabel setText:@"订单已发货，您买的电饭锅已发货"];
        [_contentLabel setFont:UIFontPingFangMedium(14.0f)];
        [_contentLabel setTextColor:UIColorFromHex(0x696969, 1)];
        [bgView addSubview:_contentLabel];
        
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
