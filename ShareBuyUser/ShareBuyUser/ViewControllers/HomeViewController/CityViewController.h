//
//  CityViewController.h
//  ShareBuyUser
//
//  Created by soldier on 16/8/17.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "BaseViewController.h"

@protocol CityViewControllerDelegate <NSObject>

- (void)chooseCity:(NSDictionary *)cityDic;

@end

@interface CityViewController : BaseViewController

@property (nonatomic, assign) id <CityViewControllerDelegate> delegate;

@end
