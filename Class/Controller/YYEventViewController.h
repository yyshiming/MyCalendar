//
//  YYAddEventVC.h
//  MyCalendar
//
//  Created by Zsm on 15/12/16.
//  Copyright © 2015年 zhang. All rights reserved.
//

#import "YYBaseSettingVC.h"

typedef NS_ENUM(NSInteger, EventState) {
    EventStateAdd = 0,
    EventStateEdit,
};
@interface YYEventViewController : YYBaseSettingVC

@property (nonatomic, assign) EventState eventState;
@property (nonatomic, strong) NSString *dateString;
@property (nonatomic, strong) NSDictionary *contents;

@end

UIKIT_EXTERN NSString *const kEventDidChangedNotification;
