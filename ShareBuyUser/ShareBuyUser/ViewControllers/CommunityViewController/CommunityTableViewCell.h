//
//  CommunityTableViewCell.h
//  ShareBuyUser
//
//  Created by 刘兵 on 16/8/8.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommunityTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIScrollView *imgScorllView;
@property (nonatomic, strong) UIImageView *headPhotoImg;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) NSDictionary *model;

@end
