//
//  ShareCell.h
//  ShareBuyUser
//
//  Created by soldier on 16/8/24.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareCell : UITableViewCell

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIScrollView *imgScorllView;
@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) NSDictionary *model;

@end
