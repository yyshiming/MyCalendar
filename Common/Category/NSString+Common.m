//
//  NSString+MD5.m
//  KDBCommon
//
//  Created by zhangshiming on 15/5/16.
//  Copyright (c) 2015年 zhangshiming. All rights reserved.
//

#import "NSString+Common.h"
#import <CommonCrypto/CommonDigest.h>

NSString *kDateFormatStringDefault = @"yyyy-MM-dd HH:mm:ss";
NSString *const kDateFormatString = @"yyyy-MM-dd";
NSString *const kTimeFormatString = @"HH:mm:ss";
@implementation NSString (Common)

+ (NSString*)UUIDString{
    CFUUIDRef puuid = CFUUIDCreate(nil);
    CFStringRef uuidString = CFUUIDCreateString(nil, puuid);
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

+ (NSString *)stringFromTimeInterval:(id)timeInnterval
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:(NSString *)kDateFormatStringDefault];
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:[timeInnterval longLongValue]];
    NSString *str = [dateFormatter stringFromDate:date];
    return str;
}
+ (NSString *)stringFromDate:(NSDate *)date
{
    return [NSString stringFromDate:date formatter:kDateFormatStringDefault];
}
+ (NSString *)stringFromDate:(NSDate *)date formatter:(NSString *)formatString
{
    if (date == nil) return nil;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatString];
    return [dateFormatter stringFromDate:date];
}
+ (NSString *)stringFromTimeInterval:(NSTimeInterval)interval formate:(NSString *)formate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formate];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    return [formatter stringFromDate:date];
}
@end

@implementation NSString (ImageCachePath)

// 获取图片缓存文件夹路径
+ (NSString *)imageCachePath
{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *imageCachePath = [cachePath stringByAppendingPathComponent:@"ImageCaches"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:imageCachePath]) {
        [fm createDirectoryAtPath:imageCachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return imageCachePath;
}
// 根据图片地址获取该图片存储路径
+ (NSString *)pathForImageWithURLString:(NSString *)urlSting
{
    return [[NSString imageCachePath] stringByAppendingPathComponent:[urlSting MD5]];
}

@end
@implementation NSString (MD5)

- (NSString *)MD5
{
    if(self == nil || [self length] == 0)
        return nil;
    
    // Create pointer to the string as UTF8
    const char *ptr = [self UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 bytes MD5 hash value, store in buffer
    CC_MD5(ptr, (CC_LONG)strlen(ptr), md5Buffer);
    
    // Convert unsigned char buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x",md5Buffer[i]];
    }
    
    return output;
}

@end
