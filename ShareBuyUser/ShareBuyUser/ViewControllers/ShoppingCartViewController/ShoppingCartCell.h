//
//  ShoppingCartCell.h
//  ShareBuyUser
//
//  Created by soldier on 16/8/9.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShoppingCartCellDelegate;

@interface ShoppingCartCell : UITableViewCell

@property (nonatomic, strong) UIButton *checkButton;
@property (nonatomic, strong) UIImageView *productImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UIButton *minusButton;
@property (nonatomic, strong) UIButton *plusButton;

@property (nonatomic, assign) id<ShoppingCartCellDelegate> delegate;

@end

@protocol ShoppingCartCellDelegate <NSObject>

- (void)shoppingCartMinusBtn:(ShoppingCartCell *)cell;
- (void)shoppingCartPlusBtn:(ShoppingCartCell *)cell;
- (void)shoppingCartCheckBtn:(ShoppingCartCell *)cell;


@end
