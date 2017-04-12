//
//  MineTableViewHeaderView.h
//  ShareBuyUser
//
//  Created by Marx on 16/8/9.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MineTableViewHeaderView;
@protocol MineTableViewHeaderViewDelegate <NSObject>

- (void)selectLoginButtonWithMineTableViewHeader:(MineTableViewHeaderView *)headerView;
- (void)selectPersonalInfo;

@end

@interface MineTableViewHeaderView : UITableViewHeaderFooterView

@property(nonatomic)UIImageView *bgImageView;

@property(nonatomic)UIImageView *userAvatarImageView;

@property(nonatomic)UIButton *loginButton;

@property(nonatomic)UILabel *nickLabel;

@property(nonatomic)id<MineTableViewHeaderViewDelegate>delegate;

@end
