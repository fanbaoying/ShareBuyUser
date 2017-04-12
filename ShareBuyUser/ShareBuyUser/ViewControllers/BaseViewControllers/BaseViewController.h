//
//  BaseViewController.h
//  ShareBuyUser
//
//  Created by soldier on 16/8/8.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoDataView.h"
#import "BaseNavController.h"

@interface BaseViewController : UIViewController <NoDataViewDelegate>

@property (nonatomic, strong) NoDataView *nodataView;
@property(nonatomic, retain)UILabel *titleLabel;
@property(nonatomic)BaseNavController *nav;

@end
