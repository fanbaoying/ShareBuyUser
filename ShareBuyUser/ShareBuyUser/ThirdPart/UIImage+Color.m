//
//  UIImage+Color.m
//  JinKoCloud
//
//  Created by Marx on 15/11/10.
//  Copyright © 2015年 Marx. All rights reserved.
//

#import "UIImage+Color.h"

@implementation UIImage (Color)


+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}
@end
