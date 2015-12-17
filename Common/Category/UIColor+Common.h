//
//  UIColor+HexColor.h
//  ZeeReadBookStore
//
//  Created by 史占英 on 14-6-4.
//  Copyright (c) 2014年 ZeeGuo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UIColor (Common)

/**
 *  根据十六进制数设置颜色
 *
 *  @param hexValue 十六进制颜色值
 *  @param alpha    透明度
 *
 *  @return UIColor对象
 */
+ (UIColor *)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alpha;

/**
 *  根据十六进制数设置颜色
 *
 *  @param hexValue 十六进制颜色值
 *
 *
 *  @return UIColor对象
 */
+ (UIColor *)colorWithHex:(NSInteger)hexValue;

@end
