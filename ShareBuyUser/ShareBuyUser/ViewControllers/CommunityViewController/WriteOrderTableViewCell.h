//
//  WriteOrderTableViewCell.h
//  ShareBuyUser
//
//  Created by 刘兵 on 16/8/10.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WriteOrderTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *img;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) NSDictionary *model;

@end
