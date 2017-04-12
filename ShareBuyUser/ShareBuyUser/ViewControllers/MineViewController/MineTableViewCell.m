//
//  MineTableViewCell.m
//  ShareBuyUser
//
//  Created by Marx on 16/8/9.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "MineTableViewCell.h"

@implementation MineTableViewCell

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
    [self.textLabel setTextColor:UIColorFromHex(0x3c3c3c, 1)];
    [self.textLabel setFont:UIFontPingFangRegular(15)];
    
}

- (void)setDic:(NSDictionary *)dic
{
    _dic = dic;
    [self.imageView setImage:[UIImage imageNamed:_dic[@"image"]]];
    [self.textLabel setText:dic[@"title"]];
    if ([_dic[@"title"] isEqualToString:@"我的账户"]) {
        [self setAccessoryType:UITableViewCellAccessoryNone];
//        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_arrow_right_image"]];
    }else{
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_arrow_right_image"]];
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
