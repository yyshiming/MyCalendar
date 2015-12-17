//
//  UIColor+HexColor.m
//  ZeeReadBookStore
//
//  Created by 史占英 on 14-6-4.
//  Copyright (c) 2014年 ZeeGuo Inc. All rights reserved.
//

#import "UIColor+Common.h"

@implementation UIColor (Common)

+ (UIColor *)colorWithHex:(NSInteger)hexValue
{
    return [UIColor colorWithHex:hexValue alpha:1.0];
}

+ (UIColor *)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((CGFloat)((hexValue & 0xFF0000) >> 16)) / 255.0
                           green:((CGFloat)((hexValue & 0xFF00) >> 8)) / 255.0
                            blue:((CGFloat)(hexValue & 0xFF))/255.0
                           alpha:alpha];
}
@end
