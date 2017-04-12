//
//  AddressTableViewCell.h
//  ShareBuyUser
//
//  Created by Marx on 16/8/17.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddressTableViewCell;
@protocol AddressTableViewCellDelegate <NSObject>

- (void)selectDefaultButtonOnAddressTableViewCell:(AddressTableViewCell *)cell;

@end

@interface AddressTableViewCell : UITableViewCell

@property(nonatomic)UIButton *defaultButton;

@property(nonatomic)UILabel *nameLabel;
@property(nonatomic)UILabel *phoneLabel;
@property(nonatomic)UILabel *addressLabel;

@property(nonatomic)id<AddressTableViewCellDelegate>delegate;

@end
