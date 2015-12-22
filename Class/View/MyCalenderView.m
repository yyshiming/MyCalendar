//
//  MyCalenderView.m
//  KDBCommon
//
//  Created by Zsm on 15/12/11.
//  Copyright © 2015年 YY. All rights reserved.
//

#import "MyCalenderView.h"
#import <math.h>

#define D_Value 0.2422
#define kFontSize1 16
#define kFontSize2 11
@implementation MyCalenderView {
    NSCalendar *_theCalender;
    
    UIView     *_dateView;
    
    NSMutableArray *_daysInPreviousMonth;
    NSMutableArray *_daysInCurrentMonth;
    NSMutableArray *_daysInNextMonth;
    NSMutableArray *_calendarDays;
    
    NSMutableArray *_buttons;
    

}

- (void)configureData
{
    self.backgroundColor = [UIColor whiteColor];
    _daysInPreviousMonth = [NSMutableArray array];
    _daysInCurrentMonth = [NSMutableArray array];
    _daysInNextMonth = [NSMutableArray array];
    _calendarDays = [NSMutableArray array];
    _buttons = [NSMutableArray array];
    
    _theCalender = [NSCalendar currentCalendar];
    
    self.selectedDate = [NSDate date];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configureData];
        [self createUI];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureData];
        [self createUI];
    }
    return self;
}
- (void)setSelectedDate:(NSDate *)selectedDate
{
    NSCalendarUnit unit = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
    NSDateComponents *components = [_theCalender components:unit fromDate:selectedDate];
    
    NSDate *newDate = [_theCalender dateFromComponents:components];
    if (_selectedDate && [newDate compare:_selectedDate] == NSOrderedSame) {
        return;
    }
    BOOL isEquelMonth = NO;
    if (_selectedDate && [[newDate firstDateOfCurrentMonth] compare:[_selectedDate firstDateOfCurrentMonth]] == NSOrderedSame) {
        isEquelMonth = YES;
    }
    _selectedDate = newDate;
    
    _dateString = [NSString stringFromDate:_selectedDate formatter:kDateFormatString];
    ChineseDate *chineseDate = [ChineseDate chineseDateWithDate:_selectedDate];
    _chineseDateString = chineseDate.fullString;
    
    if (isEquelMonth) {
        [self reloadButtons];
    }
    else {
        [self resetButtons];
    }
    
}

- (NSDate *)dateWithString:(NSString *)string
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyy-MM-dd"];
    return [formatter dateFromString:string];
}
- (void)createUI
{
    _dateView = [[UIView alloc] init];
    [self addSubview:_dateView];
    
//    for (NSInteger i = 0; i < 7*6; i++) {
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        button.titleLabel.textAlignment = NSTextAlignmentCenter;
//        button.titleLabel.numberOfLines = 2;
//        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//        [_buttons addObject:button];
//    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];

    _dateView.frame = CGRectMake(0, 0, self.viewWidth, self.viewHeight);

    
    [_dateView removeAllSubViews];
    [_buttons removeAllObjects];
    
    CGFloat buttonWidth = self.viewWidth/7;
    CGFloat height = buttonWidth;
    CGFloat line = _calendarDays.count/7;
    CGFloat space = (_dateView.viewHeight - line*height)/(line-1);
    for (NSInteger i = 0; i < _calendarDays.count; i++) {
//        UIButton *button = _buttons[i];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.numberOfLines = 2;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i+1;
        button.frame = CGRectMake((i%7)*buttonWidth, (i/7)*(height+space), buttonWidth, height);
        
        [_dateView addSubview:button];
        
        
        NSDateComponents *components = _calendarDays[i];
        NSDate *date = [_theCalender dateFromComponents:components];
        ChineseDate *chineseDate = [ChineseDate chineseDateWithDate:date];
        
        NSString *string = chineseDate.dayString;
        if (chineseDate.isFirstDayOfMonth) {           // 农历每个月的第一天
            string = chineseDate.monthString;
        }
        if (chineseDate.holidayString) {               // 西方节日
            string = chineseDate.holidayString;
        }
        if (chineseDate.chineseHolidayString) {        // 中国节日
            string = chineseDate.chineseHolidayString;
        }
        if (chineseDate.jieQiString) {                 // 属于二十四节气
            string = chineseDate.jieQiString;
        }
        
        if (string.length > 4) {
            string = [string substringWithRange:NSMakeRange(0, 4)];
        }
        
        NSString *title = [NSString stringWithFormat:@"%@\n%@", @(components.day), string];
        NSRange range = NSMakeRange(0, title.length);
        NSRange range1 = [title rangeOfString:[NSString stringWithFormat:@"%@", @(components.day)]];
        NSRange range2 = [title rangeOfString:string];
        
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:title];
        [attrStr addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:kFontSize1]} range:range1];
        [attrStr addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:kFontSize2]} range:range2];
        
        UIColor *color = [YYConfigure colorForKey:kDefaultAppColorKey];
        // 节气日期
        if (chineseDate.jieQiString ||
            chineseDate.chineseHolidayString ||
            chineseDate.holidayString) {
            [attrStr addAttributes:@{NSForegroundColorAttributeName: color} range:range2];
        }
        // 周六、周日
        NSUInteger week = [date weekOfCurrentDate];
        if (week == 1 || week == 7) {
            [attrStr addAttributes:@{NSForegroundColorAttributeName: color} range:range1];
        }
        // 上个月或下个月的日期颜色
        if ([_daysInPreviousMonth containsObject:components] ||
            [_daysInNextMonth containsObject:components]) {
            [attrStr addAttributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]} range:range];
            
        }
        // 选中的日期
        if ([date compare:_selectedDate] == NSOrderedSame) {
            button.backgroundColor = kSelectedBackGroundColor;
        }
        
        // 今天的日期标为红色
        NSCalendarUnit unit = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
        NSDateComponents *theComponents = [_theCalender components:unit fromDate:[NSDate date]];
        NSDate *today = [_theCalender dateFromComponents:theComponents];
        if ([today compare:date] == NSOrderedSame) {
            [attrStr addAttributes:@{NSForegroundColorAttributeName: [UIColor redColor]} range:range];
        }
        
        [button setAttributedTitle:attrStr forState:UIControlStateNormal];
        
        [_buttons addObject:button];
    }
}
- (void)resetButtons
{
    [_daysInPreviousMonth removeAllObjects];
    [_daysInCurrentMonth removeAllObjects];
    [_daysInNextMonth removeAllObjects];
    [_calendarDays removeAllObjects];
    [self calculateDaysInPreviousMonth];
    [self calculateDaysInCurrentMonth];
    [self calculateDaysInNextMonth];
    
    [self setNeedsLayout];
}
- (void)reloadButtons
{
    for (NSInteger i = 0; i < _buttons.count; i++) {
        UIButton *button = _buttons[i];
        NSDateComponents *components = _calendarDays[i];
        NSDate *date = [_theCalender dateFromComponents:components];
        if ([date compare:_selectedDate] == NSOrderedSame) {
            button.backgroundColor = kSelectedBackGroundColor;
        }
        else {
            button.backgroundColor = [UIColor whiteColor];
        }
    }
}
- (void)buttonAction:(UIButton *)button
{
    NSUInteger index = button.tag - 1;
    NSDateComponents *components = _calendarDays[index];
    self.selectedDate = [_theCalender dateFromComponents:components];
    
    if ([self.delegate respondsToSelector:@selector(calendarView:didSelectButton:)]) {
        [self.delegate calendarView:self didSelectButton:button];
    }
}
- (void)calculateDaysInPreviousMonth
{
    NSUInteger weeklyOrdinality = [[_selectedDate firstDateOfCurrentMonth] weekOfCurrentDate];
    NSDate *previousMonthDate = [_selectedDate firstDateOfPreviousMonth];
    
    NSUInteger daysInPreviousMonth = [previousMonthDate numberOfDaysInCurrentMonth];
    NSUInteger partialDaysCount = weeklyOrdinality - 1;
    
    NSCalendarUnit unit = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;

    for (NSInteger i = daysInPreviousMonth - partialDaysCount + 1; i < daysInPreviousMonth + 1; ++i) {
        NSDateComponents *components = [_theCalender components:unit fromDate:previousMonthDate];
        components.day = i;
        [_daysInPreviousMonth addObject:components];
        [_calendarDays addObject:components];
    }
}

- (void)calculateDaysInCurrentMonth
{
    NSUInteger daysCount = [_selectedDate numberOfDaysInCurrentMonth];
    NSCalendarUnit unit = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
    
    for (int i = 1; i < daysCount + 1; ++i) {
        NSDateComponents *components = [_theCalender components:unit fromDate:_selectedDate];
        components.day = i;
        [_daysInCurrentMonth addObject:components];
        [_calendarDays addObject:components];
    }
}

- (void)calculateDaysInNextMonth
{
    NSUInteger weeklyOrdinality = [[_selectedDate lastDayOfCurrentMonth] weekOfCurrentDate];
    if (weeklyOrdinality == 7) return ;
    
    NSUInteger partialDaysCount = 7 - weeklyOrdinality;
    NSCalendarUnit unit = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
    
    for (int i = 1; i < partialDaysCount + 1; ++i) {
        NSDateComponents *components = [_theCalender components:unit fromDate:[_selectedDate firstDateOfNextMonth]];
        components.day = i;
        [_daysInNextMonth addObject:components];
        [_calendarDays addObject:components];
    }
}

@end

#pragma mark - NSDateHelper
@implementation NSDate (NSDateHelper)

- (NSCalendar *)theCalendar
{
    static NSCalendar *calendar;
    if (calendar == nil) {
        calendar = [NSCalendar currentCalendar];
    }
    return calendar;
}

#pragma mark 确定这个月第一天的日期
- (NSDate *)firstDateOfCurrentMonth
{
    NSDate *startDate = nil;
    BOOL ok = [[self theCalendar] rangeOfUnit:NSCalendarUnitMonth startDate:&startDate interval:NULL forDate:self];
    NSAssert1(ok, @"Failed to calculate the first day of the month based on %@", self);
    return startDate;
}
#pragma mark 上一个月第一天的日期
- (NSDate *)firstDateOfPreviousMonth
{
    NSCalendarUnit unit = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
    NSDateComponents *components = [[self theCalendar] components:unit fromDate:self];
    if (components.month == 1) {
        components.month = 12;
        components.year -= 1;
    }
    else {
        components.month -= 1;
    }
    components.day = 1;
    return [[self theCalendar] dateFromComponents:components];
}
#pragma mark 下一个月第一天的日期
- (NSDate *)firstDateOfNextMonth
{
    NSCalendarUnit unit = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
    NSDateComponents *components = [[self theCalendar] components:unit fromDate:self];
    if (components.month == 12) {
        components.month = 1;
        components.year += 1;
    }
    else {
        components.month += 1;
    }
    components.day = 1;
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}
- (NSDate *)lastDayOfCurrentMonth
{
    NSCalendarUnit unit = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
    NSDateComponents *components = [[self theCalendar] components:unit fromDate:self];
    components.day = [self numberOfDaysInCurrentMonth];
    NSDate *lastDayDate = [[self theCalendar] dateFromComponents:components];
    return lastDayDate;
}
#pragma mark 这一天是周几
// 周日为1
- (NSUInteger)weekOfCurrentDate
{
    return [[self theCalendar] ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:self];
}
#pragma mark 这个月有多少天
- (NSUInteger)numberOfDaysInCurrentMonth
{
    return [[self theCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self].length;
}
#pragma mark 这个月有多少周
- (NSUInteger)numberOfWeeksInCurrentMonth
{
    NSUInteger weekday = [[self firstDateOfCurrentMonth] weekOfCurrentDate];
    
    NSUInteger days = [self numberOfDaysInCurrentMonth];
    NSUInteger weeks = 0;
    
    if (weekday > 1) {
        weeks += 1, days -= (7 - weekday + 1);
    }
    
    weeks += days / 7;
    weeks += (days % 7 > 0) ? 1 : 0;
    
    return weeks;
}


@end

#pragma mark - 农历日历
@implementation ChineseDate {
    NSDate *_theDate;
}
+ (instancetype)chineseDateWithDate:(NSDate *)date
{
    return [[self alloc] initWithDate:date];
}
- (instancetype)initWithDate:(NSDate *)date
{
    self = [super init];
    if (self) {
        
        _theDate = date;
        NSArray *chineseYears = [NSArray arrayWithObjects:
                                 @"甲子", @"乙丑", @"丙寅", @"丁卯",  @"戊辰",  @"己巳",  @"庚午",  @"辛未",  @"壬申",  @"癸酉",
                                 @"甲戌",   @"乙亥",  @"丙子",  @"丁丑", @"戊寅",   @"己卯",  @"庚辰",  @"辛己",  @"壬午",  @"癸未",
                                 @"甲申",   @"乙酉",  @"丙戌",  @"丁亥",  @"戊子",  @"己丑",  @"庚寅",  @"辛卯",  @"壬辰",  @"癸巳",
                                 @"甲午",   @"乙未",  @"丙申",  @"丁酉",  @"戊戌",  @"己亥",  @"庚子",  @"辛丑",  @"壬寅",  @"癸丑",
                                 @"甲辰",   @"乙巳",  @"丙午",  @"丁未",  @"戊申",  @"己酉",  @"庚戌",  @"辛亥",  @"壬子",  @"癸丑",
                                 @"甲寅",   @"乙卯",  @"丙辰",  @"丁巳",  @"戊午",  @"己未",  @"庚申",  @"辛酉",  @"壬戌",  @"癸亥", nil];
        
        NSArray *chineseMonths=[NSArray arrayWithObjects:
                                @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                                @"九月", @"十月", @"冬月", @"腊月", nil];
        
        
        NSArray *chineseDays=[NSArray arrayWithObjects:
                              @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                              @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                              @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
        NSArray *shengXiaoArray = @[@"鼠年", @"牛年", @"虎年", @"兔年", @"龙年", @"蛇年",
                                    @"马年", @"羊年", @"猴年", @"鸡年", @"狗年", @"猪年"];
    
        
        NSCalendar *chineseCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
        NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
        NSDateComponents *chineseComp = [chineseCalendar components:unitFlags fromDate:date];
        
        if (chineseComp.day == 1) {
            _isFirstDayOfMonth = YES;
        }
        else {
            _isFirstDayOfMonth = NO;
        }
        _yearString = [chineseYears objectAtIndex:chineseComp.year-1];
        _monthString = [chineseMonths objectAtIndex:chineseComp.month-1];
        _dayString = [chineseDays objectAtIndex:chineseComp.day-1];
        
        NSUInteger index = chineseComp.year%12 - 1;
        _shengXiaoString = shengXiaoArray[index];
        
        _fullString = [NSString stringWithFormat:@"%@%@%@%@", _yearString, _shengXiaoString, _monthString, _dayString];
        
        _jieQiString = [self calculateJieQiWithDate:_theDate];     // 节气
        _holidayString = [self configureHolidayWithDate:_theDate]; // 西方节日
        _chineseHolidayString = [self configureChineseHolidayWithDate:_theDate]; // 中国节日
        
        
        // 特殊节日
        NSDate *date = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitDay value:15 toDate:_theDate options:NSCalendarWrapComponents];
        if ([[self calculateJieQiWithDate:date] isEqualToString:@"春分"]) {
            _holidayString = @"清明节";
        }
        
        
        NSCalendar *localeCalendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [localeCalendar components:unitFlags fromDate:date];
        if (components.month == 5) {
            NSInteger count = 0;
            for (NSInteger i = 1; i < 21; i++) {
                components.day = i;
                NSDate *newDate = [localeCalendar dateFromComponents:components];
                 NSUInteger week = [newDate weekOfCurrentDate];
                if (week == 1) {
                    count ++;
                }
                if (count == 2) {
                    NSDateComponents *theComponents = [localeCalendar components:unitFlags fromDate:_theDate];
                    if (theComponents.day == i) {
                        _holidayString = @"母亲节";
                    }
                    break;
                }
            }
        }
        if (components.month == 6) {
            NSInteger count = 0;
            for (NSInteger i = 1; i < 28; i++) {
                components.day = i;
                NSDate *newDate = [localeCalendar dateFromComponents:components];
                NSUInteger week = [newDate weekOfCurrentDate];
                if (week == 1) {
                    count ++;
                }
                if (count == 3) {
                    NSDateComponents *theComponents = [localeCalendar components:unitFlags fromDate:_theDate];
                    if (theComponents.day == i) {
                        _holidayString = @"父亲节";
                    }
                    break;
                }
            }
        }
    }
    return self;
}
// 计算节气
- (NSString *)calculateJieQiWithDate:(NSDate *)date
{
    
    NSCalendar *localeCalendar = [NSCalendar currentCalendar];
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *components = [localeCalendar components:unitFlags fromDate:date];
    NSArray *jieQiArray = @[@[@"立春", @"雨水"], @[@"惊蛰", @"春分"], @[@"清明", @"谷雨"],
                            @[@"立夏", @"小满"], @[@"芒种", @"夏至"], @[@"小暑", @"大暑"],
                            @[@"立秋", @"处暑"], @[@"白露", @"秋分"], @[@"寒露", @"霜降"],
                            @[@"立冬", @"小雪"], @[@"大雪", @"冬至"], @[@"小寒", @"大寒"]];
    
    NSArray *c_values_21 = @[@[@"3.85", @"18.73"], @[@"5.63", @"20.646"], @[@"4.81", @"20.1"],
                             @[@"5.52", @"21.04"], @[@"5.678", @"21.37"], @[@"7.108", @"22.83"],
                             @[@"7.5", @"23.13"], @[@"7.646", @"23.042"], @[@"8.318", @"23.438"],
                             @[@"7.438", @"22.36"], @[@"7.18", @"21.94"], @[@"5.4055", @"20.12"]];
    NSArray *jieQiMonth = @[@"2", @"3" ,@"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12", @"1"];
    NSUInteger index = [jieQiMonth indexOfObject:[NSString stringWithFormat:@"%@",@(components.month)]];
    NSInteger Y = components.year % 100;
    CGFloat c1 = [c_values_21[index][0] floatValue];
    CGFloat c2 = [c_values_21[index][1] floatValue];
    CGFloat L;
    if (components.month == 1 || components.month == 2) {
        L = (Y-1)/4;
    }
    else {
        L = Y/4;
    }
    NSUInteger day1 = floorf(Y * D_Value + c1) - floorf(L);
    NSUInteger day2 = floorf(Y * D_Value + c2) - floorf(L);
    
    
    NSString *jieQiString = nil;
    if (day1 == components.day) {
        jieQiString = jieQiArray[index][0];
    }
    if (day2 == components.day) {
        jieQiString = jieQiArray[index][1];
    }
    return jieQiString;
}

// 西方节日
- (NSString *)configureHolidayWithDate:(NSDate *)date
{
    NSString *holidayString = nil;
    
    NSCalendar *localeCalendar = [NSCalendar currentCalendar];
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *components = [localeCalendar components:unitFlags fromDate:date];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"holiday" ofType:@"plist"];
    NSDictionary *holiday = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSString *monthString = [NSString stringWithFormat:@"%@", @(components.month)];
    NSString *dayString = [NSString stringWithFormat:@"%@", @(components.day)];
    id monthContent = holiday[monthString];
    if ([monthContent isKindOfClass:[NSDictionary class]]) {
        id dayContent = monthContent[dayString];
        if ([dayContent isKindOfClass:[NSArray class]]) {
            id holidayStrs = [dayContent firstObject];
            if ([holidayStrs isKindOfClass:[NSString class]]) {
                holidayString = holidayStrs;
            }
        }
    }
    
    return holidayString;
}
// 中国节日
- (NSString *)configureChineseHolidayWithDate:(NSDate *)date
{
    NSString *chineseHolidayString = nil;
    
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *components = [localeCalendar components:unitFlags fromDate:date];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"chinese_holiday" ofType:@"plist"];
    NSDictionary *holiday = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSString *monthString = [NSString stringWithFormat:@"%@", @(components.month)];
    NSString *dayString = [NSString stringWithFormat:@"%@", @(components.day)];
    
    if (components.month == 12) {
        NSInteger days =  [localeCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:_theDate].length;
        if (components.day == days) {
            chineseHolidayString = @"除夕";
            return chineseHolidayString;
        }
    }
    id monthContent = holiday[monthString];
    if ([monthContent isKindOfClass:[NSDictionary class]]) {
        id holidayStrs = monthContent[dayString];
        if ([holidayStrs isKindOfClass:[NSString class]]) {
            chineseHolidayString = holidayStrs;
        }
    }
    
    return chineseHolidayString;
}

@end
