//
//  OrderTableViewFooterView.h
//  ShareBuyUser
//
//  Created by Marx on 16/8/10.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderTableViewFooterView;
@protocol OrderTableViewFooterViewDelegate <NSObject>

-(void)selectFooterViewPayButtonWithSection:(NSInteger)section;
-(void)selectFooterViewCancelButtonWithSection:(NSInteger)section;
-(void)selectFooterViewConfirmButtonWithSection:(NSInteger)section;
-(void)selectFooterViewCommentButtonWithSection:(NSInteger)section;
-(void)selectFooterViewRefundButtonWithSection:(NSInteger)section;

@end

@interface OrderTableViewFooterView : UITableViewHeaderFooterView

@property(nonatomic)UILabel *orderInfoLabel;

@property(nonatomic)UIButton *payButton;
@property(nonatomic)UIButton *cancelButton;
@property(nonatomic)UIButton *confirmButton;
@property(nonatomic)UIButton *commentButton;
@property(nonatomic)UIButton *refundButton;
@property(nonatomic)NSInteger section;

@property(nonatomic)id<OrderTableViewFooterViewDelegate>delegate;

@end
