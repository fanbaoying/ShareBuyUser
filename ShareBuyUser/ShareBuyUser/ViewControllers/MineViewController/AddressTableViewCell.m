//
//  AddressTableViewCell.m
//  ShareBuyUser
//
//  Created by Marx on 16/8/17.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "AddressTableViewCell.h"

@implementation AddressTableViewCell

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
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    
    [self.contentView addSubview:self.defaultButton];
    
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.phoneLabel];
    UIView *lineView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(30, 44.75, kScreenWidth -40, 0.5)];
        [view setBackgroundColor:UIColorFromHex(0xbbbbbb, 1)];
        view;
    });
    [self.contentView addSubview:lineView];
    UILabel *addressLabel = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 45, 50, 45)];
        [label setTextAlignment:NSTextAlignmentLeft];
        [label setTextColor:UIColorFromHex(0x696969, 1)];
        [label setFont:UIFontPingFangRegular(15)];
        [label setText:@"地址："];
        label;
    });
    [self.contentView addSubview:addressLabel];
    [self.contentView addSubview:self.addressLabel];
}

- (UIButton *)defaultButton
{
    if (!_defaultButton) {
        _defaultButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(0, 30, 30, 30)];
            [button setImage:[UIImage imageNamed:@"check_normal"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"check_select"] forState:UIControlStateSelected];
            
            [button addTarget:self action:@selector(selectDefaultButton:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _defaultButton;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, (kScreenWidth-40)/2-30, 45)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextAlignment:NSTextAlignmentLeft];
            [label setTextColor:UIColorFromHex(0x999999, 1)];
            [label setFont:UIFontPingFangRegular(15)];
            
            label;
        });
    }
    return _nameLabel;
}

- (UILabel *)phoneLabel
{
    if (!_phoneLabel) {
        _phoneLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-40)/2 , 0, (kScreenWidth-40)/2+30 , 45)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextAlignment:NSTextAlignmentRight];
            [label setTextColor:UIColorFromHex(0x999999, 1)];
            [label setFont:UIFontPingFangRegular(15)];
            
            label;
        });
    }
    return _phoneLabel;
}

- (UILabel *)addressLabel
{
    if (!_addressLabel) {
        _addressLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(80, 45, kScreenWidth-90, 45)];
            [label setTextAlignment:NSTextAlignmentRight];
            [label setTextColor:UIColorFromHex(0x999999, 1)];
            [label setFont:UIFontPingFangRegular(15)];
            label;
        });
    }
    return _addressLabel;
}

- (IBAction)selectDefaultButton:(UIButton *)sender
{
    if (!sender.selected) {
        [self.delegate selectDefaultButtonOnAddressTableViewCell:self];
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
