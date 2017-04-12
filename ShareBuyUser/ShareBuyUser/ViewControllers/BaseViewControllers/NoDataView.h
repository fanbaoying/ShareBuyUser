//
//  NoDataView.h
//  ShareBuyUser
//
//  Created by soldier on 16/8/8.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NoDataViewDelegate <NSObject>

- (void)refreshNetworking;

@end

@interface NoDataView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *functionButton;

@property (nonatomic, assign) id <NoDataViewDelegate> delegate;

- (void)setMessage:(NSString *)message AndTitle:(NSString *)title AndImage:(UIImage *)image;

@end
