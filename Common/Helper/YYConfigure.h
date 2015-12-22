//
//  YYConfigure.h
//  MyCalendar
//
//  Created by Zsm on 15/12/22.
//  Copyright © 2015年 zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYConfigure : NSObject

+ (YYConfigure *)sharedConfigure;
+ (void)configureDefaultValue;

+ (UIColor *)colorForKey:(NSString *)key;
+ (void)setColor:(UIColor *)color forKey:(NSString *)key;

@end

UIKIT_EXTERN NSString *const kAppColorDidChangedNotification;
