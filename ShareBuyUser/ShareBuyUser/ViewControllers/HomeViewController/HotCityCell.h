//
//  HotCityCell.h
//  ShareBuyUser
//
//  Created by soldier on 16/8/17.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HotCityCell;
@protocol HotCityCellDelegate<NSObject>

- (void)hotCityCell:(HotCityCell *)cell selectedButtonWithTag:(NSInteger)tag;

@end

@interface HotCityCell : UITableViewCell

@property (nonatomic ,strong) NSArray *hotCityArray;
@property(nonatomic ,assign) id<HotCityCellDelegate> delegate;

@end
