//
//  ScanQrCodeView.m
//  ShareBuyUser
//
//  Created by soldier on 16/8/9.
//  Copyright © 2016年 ShareBuy. All rights reserved.
//

#import "ScanQrCodeView.h"

@implementation ScanQrCodeView

- (void)drawRect:(CGRect)rect {
    CGRect screenDrawRect =CGRectMake(0, 0, kScreenWidth,kScreenHeight - kNavigationBarHight);
//    CGRect screenDrawRect = CGRectMake((kScreenWidth - 220)/2, (kScreenHeight-kNavigationBarHight-220)/2, 220, 220);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(ctx, 0, 0, 0, 0.6);
    CGContextFillRect(ctx, screenDrawRect);
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 200*kWR)/2, 112*kWR, 200*kWR, 200*kWR)];
    img.image = [UIImage imageNamed:@"scan_scanImg"];
    [self addSubview:img];
    CGContextClearRect(ctx, img.frame);
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
