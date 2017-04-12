//
//  ActivityCollectionViewCell.m
//  ShareBuyUser
//
//  Created by soldier on 16/8/9.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "ActivityCollectionViewCell.h"

@implementation ActivityCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    [self setBackgroundColor:[UIColor whiteColor]];
    
    _activityImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
    [_activityImgView setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@""]];
    [self addSubview:_activityImgView];
    
    _activityTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.width, self.frame.size.width, 20)];
    [_activityTitleLabel setText:@"夏天自营制品"];
    [_activityTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [_activityTitleLabel setTextColor:UIColorFromHex(0x3c3c3c, 1)];
    [_activityTitleLabel setFont:UIFontPingFangRegular(15.0f)];
    [self addSubview:_activityTitleLabel];
    
    _activitySubTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.width+20, self.frame.size.width, 20)];
    [_activitySubTitleLabel setText:@"188减88"];
    [_activitySubTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [_activitySubTitleLabel setTextColor:UIColorFromHex(0x696969, 1)];
    [_activitySubTitleLabel setFont:UIFontPingFangMedium(13.0f)];
    [self addSubview:_activitySubTitleLabel];
        
    return self;
}

@end
