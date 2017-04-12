//
//  GoodsCell.h
//  ShareBuyUser
//
//  Created by soldier on 16/8/10.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoodsCell;
@protocol ShoppingCartCellDelegate <NSObject>

- (void)numberPlus:(GoodsCell *)cell;
- (void)numberMinus:(GoodsCell *)cell;

@end

@interface GoodsCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UIButton *minusBtn;
@property (nonatomic, strong) UIButton *plusBtn;

@property (nonatomic, assign) id <ShoppingCartCellDelegate> delegate;

@end
