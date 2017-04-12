//
//  MessageDetailCell.h
//  ShareBuyUser
//
//  Created by soldier on 16/8/26.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageDetailCell : UITableViewCell

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *contentBgView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) NSDictionary *model;

@end
