//
//  UIImage+Common.h
//  KDB_Customer
//
//  Created by zhangshiming on 15/5/31.
//  Copyright (c) 2015年 雷华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Common)

/**
 *  将单一颜色转为图片类型
 *
 *  @param color 单一颜色
 *
 *  @return 转换的图片
 */
+ (UIImage *)imageFromColor:(UIColor *)color;

- (UIImage *)imageScaleToSize:(CGSize)size;

@end
