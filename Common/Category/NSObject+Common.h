//
//  NSObject+Common.h
//  KDB_Customer
//
//  Created by zhangshiming on 15/5/27.
//  Copyright (c) 2015年 雷华. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+Common.h"
#import "UIImage+Common.h"
#import "UIView+Common.h"
#import "UIColor+Common.h"

@interface NSObject (Common)

/**
 *  邮箱是否合法
 *
 *  @param email 邮箱地址
 *
 *  @return YES有效的email地址，否则无效的email地址
 */
+ (BOOL)isValidateEmail:(NSString *)email;


/**
 *  手机号是否合法
 *
 *  @param mobile 手机号
 *
 *  @return YES有效的手机号，否则无效的手机号
 */
+ (BOOL)isValidateMobile:(NSString *)mobile;

/**
 *  清除图片缓存
 *
 *  @param isAuto YES自动清理缓存时间超过一周的图片
 */
+ (void)clearImageCachesAutomatic:(BOOL)isAuto;


/**
 *  删除图片
 *
 *  @param urlString 根据图片的URL删除图片
 */
+ (void)removeImageWithURLString:(NSString *)urlString;


/**
 *  根据图片的地址保存图片
 *
 *  @param image     要保存的图片
 *  @param urlString 图片的url
 *
 *  @return YES保存成功
 */
+ (BOOL)saveImage:(UIImage *)image withURLString:(NSString *)urlString;

+ (NSDictionary *)loadDefaultCompanyInfo;

@end
