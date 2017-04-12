//
//  MarxBannerViewPage.m
//  CloudCampus
//
//  Created by Marx on 16/2/28.
//  Copyright © 2016年 Marx. All rights reserved.
//

#import "MarxBannerViewPage.h"

@interface MarxBannerViewPage() <UIGestureRecognizerDelegate>



@end

@implementation MarxBannerViewPage

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithStyle:(MarxBannerViewPageStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super init];
    if (self) {
        self.reuseIdentifier = reuseIdentifier;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)layoutSubviews
{
    
    [super layoutSubviews];
    
    [self initialize];
}

- (void)initialize
{
    // single tap gesture recognizer
    UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureRecognizer:)];
    tapGestureRecognize.delegate = self;
    tapGestureRecognize.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapGestureRecognize];
    
    if (_title.length>0) {
        
        [self addSubview:self.titleLabel];
        [_titleLabel setText:_title];
    }else{
        [_titleLabel removeFromSuperview];
    }
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setFont:[UIFont systemFontOfSize:17]];
            
            
            label;
        });
    }
    
    [_titleLabel setFrame:CGRectMake(0, 0,CGRectGetWidth(self.frame),30)];
    return _titleLabel;
}


#pragma mark - UITapGestureRecognizerSelector

- (void)singleTapGestureRecognizer:(UITapGestureRecognizer *)tapGesture {
    
    [self.delegate didSelectedMarxBannerViewPage:self];
}




@end
