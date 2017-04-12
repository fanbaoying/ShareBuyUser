//
//  ShareDetailsTableViewCell.h
//  ShareBuyUser
//
//  Created by 刘兵 on 16/8/9.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareDetailsTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *headImg;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) NSDictionary *model;

@end
