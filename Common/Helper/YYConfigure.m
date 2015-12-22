//
//  YYConfigure.m
//  MyCalendar
//
//  Created by Zsm on 15/12/22.
//  Copyright © 2015年 zhang. All rights reserved.
//

#import "YYConfigure.h"

@implementation YYConfigure

+ (YYConfigure *)sharedConfigure
{
    static YYConfigure *__shareConfigure__ = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        __shareConfigure__ = [[YYConfigure alloc] init];
    });
    return __shareConfigure__;
}


+ (void)configureDefaultValue
{
    [YYConfigure setColor:kAPPBlueColor forKey:kDefaultAppColorKey];
}
+ (void)setColor:(UIColor *)color forKey:(NSString *)key
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:color];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (UIColor *)colorForKey:(NSString *)key
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    UIColor *color = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return color;
}

NSString *const kAppColorDidChangedNotification = @"kAppColorDidChangedNotification";

@end
