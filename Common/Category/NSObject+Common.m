//
//  NSObject+Common.m
//  KDB_Customer
//
//  Created by zhangshiming on 15/5/27.
//  Copyright (c) 2015年 雷华. All rights reserved.
//

#import "NSObject+Common.h"

#define kImageCachesExistTime 7*24*60*60
@implementation NSObject (Common)


//判断邮箱是否合法
+ (BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//判断手机号是否合法
+ (BOOL)isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^(13[0-9]|14[57]|15[0-3,5-9]|17[0678]|18[0-9])\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

// 删除图片缓存文件夹
+ (void)clearImageCachesAutomatic:(BOOL)isAuto
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *path = [NSString imageCachePath];
    NSError *error = nil;
    if ([fm fileExistsAtPath:path]) {
        if (isAuto) {
            NSDictionary *fileAttribute = [fm attributesOfItemAtPath:path error:nil];
            int seconds = -[[fileAttribute fileCreationDate] timeIntervalSinceNow];
            if (seconds >= kImageCachesExistTime) {
                [fm removeItemAtPath:path error:&error];
            }
        }
        else {
            [fm removeItemAtPath:path error:&error];
        }
        if (error) {
            NSLog(@"删除图片缓存出错！%@",error);
        }
    }
}
+ (void)removeImageWithURLString:(NSString *)urlString
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *path = [NSString pathForImageWithURLString:urlString];
    NSError *error = nil;
    if ([fm fileExistsAtPath:path]) {
        [fm removeItemAtPath:path error:&error];
        if (error) {
            NSLog(@"删除图片缓存出错！%@",error);
        }
    }
}

+ (BOOL)saveImage:(UIImage *)image withURLString:(NSString *)urlString
{
    BOOL res;
    if (image) {
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
        NSString *path = [NSString pathForImageWithURLString:urlString];
        res = [imageData writeToFile:path atomically:YES];
    }
    return res;
}

+ (NSDictionary *)loadDefaultCompanyInfo
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"companyInfo" ofType:@"txt"];
    NSData *companyData = [NSData dataWithContentsOfFile:path];
    NSDictionary *companyInfo = [NSJSONSerialization JSONObjectWithData:companyData options:NSJSONReadingMutableContainers error:nil];
    return companyInfo;
}

@end
