//
//  StoreCategoryViewController.h
//  ShareBuyUser
//
//  Created by soldier on 16/8/10.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "BaseViewController.h"
#import "GoodsCell.h"

@interface StoreCategoryViewController : BaseViewController <ShoppingCartCellDelegate>

@property (nonatomic, strong) NSString *storeID;
@property (nonatomic, strong) NSString *categoryID;

@end
