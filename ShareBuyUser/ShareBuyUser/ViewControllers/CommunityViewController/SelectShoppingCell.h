//
//  ShoppingCartCell.h
//  ShareBuyUser
//
//  Created by soldier on 16/8/9.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShoppingCartCellDelegate;

@interface SelectShoppingCell : UITableViewCell

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

- (void)shoppingCartMinusBtn:(SelectShoppingCell *)cell;
- (void)shoppingCartPlusBtn:(SelectShoppingCell *)cell;
- (void)shoppingCartCheckBtn:(SelectShoppingCell *)cell;


@end
