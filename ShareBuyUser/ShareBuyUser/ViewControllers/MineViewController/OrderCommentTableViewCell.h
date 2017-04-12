//
//  OrderCommentTableViewCell.h
//  ShareBuyUser
//
//  Created by Marx on 16/8/16.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderCommentTableViewCell;
@protocol OrderCommentTableViewCellDelegate <NSObject>

- (void)orderCommentTableViewCell:(OrderCommentTableViewCell *)cell changeStar:(NSInteger)star;

@end

@interface OrderCommentTableViewCell : UITableViewCell <UITextViewDelegate>

@property(nonatomic)UIImageView *goodImageView;
@property(nonatomic)UILabel *goodNameLabel;
@property(nonatomic)NSMutableArray *starButtonArray;
@property(nonatomic)UITextView *contentTextView;

- (void)setStarValue:(NSInteger)value;

@property(nonatomic)id<OrderCommentTableViewCellDelegate>delegate;

@end
