//
//  MyCalenderView.h
//  KDBCommon
//
//  Created by Zsm on 15/12/11.
//  Copyright © 2015年 YY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyCalenderView;

@protocol MyCalendarViewDelegate <NSObject>

- (void)calendarView:(MyCalenderView *)calendarView didSelectDate:(NSDate *)date;

@end
@interface MyCalenderView : UIView

@property (nonatomic, weak) id<MyCalendarViewDelegate> delegate;
@property (nonatomic, strong) NSDate *selectedDate;

@property (nonatomic, readonly) NSString *dateString;
@property (nonatomic, readonly) NSString *chineseDateString;

- (void)resetButtons;
- (void)reloadButtons;

@end


@interface NSDate (NSDateHelper)

- (NSDate *)firstDateOfCurrentMonth;       // 这个月第一天的日期
- (NSDate *)firstDateOfPreviousMonth;      // 上一个月第一天的日期
- (NSDate *)firstDateOfNextMonth;          // 下一个月第一天的日期
- (NSDate *)lastDayOfCurrentMonth;         // 这个月的最后一天的日期
- (NSUInteger)weekOfCurrentDate;           // 这一天是周几
- (NSUInteger)numberOfDaysInCurrentMonth;  // 这个月有多少天
- (NSUInteger)numberOfWeeksInCurrentMonth; // 这个月有多少周

@end


@interface ChineseDate : NSObject

@property (nonatomic, readonly) NSString *yearString;
@property (nonatomic, readonly) NSString *monthString;
@property (nonatomic, readonly) NSString *dayString;
@property (nonatomic, readonly) NSString *fullString;
@property (nonatomic, readonly) NSString *shengXiaoString;      // 生肖属相
@property (nonatomic, readonly) NSString *jieQiString;          // 二十四节气
@property (nonatomic, readonly) NSString *holidayString;        // 西方节日
@property (nonatomic, readonly) NSString *chineseHolidayString; // 中国节日
@property (nonatomic, readonly) BOOL isFirstDayOfMonth;         // 当月第一天

+ (instancetype)chineseDateWithDate:(NSDate *)date;

@end