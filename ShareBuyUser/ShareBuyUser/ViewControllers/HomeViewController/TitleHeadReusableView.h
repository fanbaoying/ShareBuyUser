//
//  TitleHeadReusableView.h
//  ShareBuyUser
//
//  Created by soldier on 16/8/9.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TitleHeadReusableView;
@protocol TitleHeadReusableViewDelegate <NSObject>

- (void)clickTitleHeadMoreButton:(UIButton *)sender;

@end

@interface TitleHeadReusableView : UICollectionReusableView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, assign) id<TitleHeadReusableViewDelegate> delegate;

@end

