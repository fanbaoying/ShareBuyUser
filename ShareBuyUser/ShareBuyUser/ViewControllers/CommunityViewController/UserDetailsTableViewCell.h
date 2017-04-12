//
//  UserDetailsTableViewCell.h
//  ShareBuyUser
//
//  Created by 刘兵 on 16/8/12.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserDetailsTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIScrollView *imgScorllView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) NSDictionary *model;

@end
