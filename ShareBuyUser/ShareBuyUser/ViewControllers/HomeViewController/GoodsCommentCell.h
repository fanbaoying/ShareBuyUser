//
//  GoodsCommentCell.h
//  ShareBuyUser
//
//  Created by soldier on 16/9/7.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsCommentCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headImg;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) NSDictionary *model;

@end
