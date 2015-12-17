//
//  NSString+MD5.h
//  KDBCommon
//
//  Created by zhangshiming on 15/5/16.
//  Copyright (c) 2015年 zhangshiming. All rights reserved.
//

#import <Foundation/Foundation.h>

UIKIT_EXTERN NSString *kDateFormatStringDefault;
UIKIT_EXTERN NSString *const kDateFormatString;
UIKIT_EXTERN NSString *const kTimeFormatString;
@interface NSString (Common)

+ (NSString *)UUIDString;
+ (NSString *)stringFromTimeInterval:(id)timeInnterval;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSString *)stringFromDate:(NSDate *)date formatter:(NSString *)formatString;
+ (NSString *)stringFromTimeInterval:(NSTimeInterval)interval formate:(NSString *)formate;


@end

@interface NSString (ImageCachePath)

/**
 *  获取图片缓存文件夹的地址
 *
 *  @return 图片缓存文件夹的地址
 */
+ (NSString *)imageCachePath;
+ (NSString *)pathForImageWithURLString:(NSString *)urlSting;

@end

@interface NSString (MD5)

- (NSString *)MD5;

@end
