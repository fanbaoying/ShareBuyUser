//
//  LocationCityCell.m
//  ShareBuyUser
//
//  Created by soldier on 16/8/17.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "LocationCityCell.h"

@implementation LocationCityCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImageView *locationImageView = [[UIImageView alloc] init];
        [locationImageView setFrame:CGRectMake(15, 12.5, 12.5, 15)];
        [locationImageView setImage:[UIImage imageNamed:@"city_location_image"]];
        [self addSubview:locationImageView];
    
        [self addSubview:self.titleLabel];
        [self addSubview:self.locationBtn];
    }
    return self;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, kScreenWidth - 30, 20)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextColor:UIColorFromHex(0x252525, 1)];
            [label setFont:UIFontPingFangRegular(13)];
            
            label;
        });
    }
    return _titleLabel;
}

- (UIButton *)locationBtn
{
    if (!_locationBtn) {
        _locationBtn  =[[UIButton alloc] initWithFrame:CGRectMake(30, 5, 150, 30)];
        [_locationBtn setTitle:@"定位失败，请点击重试" forState:UIControlStateNormal];
        _locationBtn.layer.cornerRadius = 2;
        _locationBtn.layer.masksToBounds = YES;
        _locationBtn.layer.borderColor = UIColorFromHex(0xcccccc, 1).CGColor;
        _locationBtn.layer.borderWidth = 0.5;
        _locationBtn.titleLabel.font = UIFontPingFangLight(13);
        [_locationBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _locationBtn.hidden = YES;
    }
    return _locationBtn;
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
