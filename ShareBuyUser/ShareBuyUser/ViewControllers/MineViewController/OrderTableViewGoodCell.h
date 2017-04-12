//
//  OrderTableViewGoodCell.h
//  ShareBuyUser
//
//  Created by Marx on 16/8/10.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTableViewGoodCell : UITableViewCell


@property(nonatomic,copy)NSDictionary *dic;
@property(nonatomic)UIImageView *goodImageView;
@property(nonatomic)UILabel *goodNameLabel;
@property(nonatomic)UILabel *goodPriceLabel;
@property(nonatomic)UILabel *goodNumLabel;
@property(nonatomic)UIView *lineView;

@end
