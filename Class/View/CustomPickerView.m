//
//  CircleScrollView1.m
//  KDBCommon
//
//  Created by 张世明 on 15/7/24.
//  Copyright (c) 2015年 张世明. All rights reserved.
//

#import "CustomPickerView.h"
#import <objc/runtime.h>

@interface CustomPickerView () <UIScrollViewDelegate>
{
    NSMutableArray *_scrollViewArray; // scrollViews
    NSMutableArray *_viewArray;
    NSMutableArray *_dataArray;
    
    NSInteger _displayRowNumber;
    UIView *_line1;
    UIView *_line2;
    
    CGFloat _pageHeight;
    CustomPickerViewType _type;
    CGFloat              _space;
    NSDateComponents    *_components;
    BOOL _showReloadLabelText;
}
@property (nonatomic, assign) NSInteger currentPage;
@end
@implementation CustomPickerView

#pragma mark - Getter Setter Method
- (NSDate *)date
{
    return [[NSCalendar currentCalendar] dateFromComponents:_components];
}
- (void)setDate:(NSDate *)date
{
    if (date == nil) {
        return;
    }
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSCalendarUnit unit;
    if (_type == CustomPickerViewTypeDate) {
        unit = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
    }
    else if (_type == CustomPickerViewTypeTime) {
        unit = NSCalendarUnitHour|NSCalendarUnitMinute;
    }
    _components = [calender components:unit fromDate:date];
    
    NSArray *defaultArray;
    if (_type == CustomPickerViewTypeDate) {
        defaultArray = @[[NSNumber numberWithInteger:_components.year],
                  [NSNumber numberWithInteger:_components.month],
                  [NSNumber numberWithInteger:_components.day]];
    }
    else if (_type == CustomPickerViewTypeTime) {
        defaultArray = @[[NSNumber numberWithInteger:_components.hour],
                  [NSNumber numberWithInteger:_components.minute]];
    }
    for (NSInteger i = 0; i < _scrollViewArray.count; i++) {
        UIScrollView *scrollView = [_scrollViewArray objectAtIndex:i];
        scrollView.currentPage = [_dataArray[i] indexOfObject:defaultArray[i]];
        scrollView.middlePage = [_dataArray[i] indexOfObject:defaultArray[i]];
    }
}
- (void)setDateString:(NSString *)dateString
{
    self.date = [[self dateFormatter] dateFromString:dateString];
}
- (NSString *)dateString
{    
    return [[self dateFormatter] stringFromDate:self.date];
}
- (NSDateFormatter *)dateFormatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *formateString;
    if (_type == CustomPickerViewTypeDate) {
        formateString = @"yyyy-MM-dd";
    }
    else if (_type == CustomPickerViewTypeTime) {
        formateString = @"HH:mm";
    }
    [dateFormatter setDateFormat:formateString];
    return dateFormatter;
}
- (NSInteger)numberOfDaysInCurrentMonth:(NSInteger)month year:(NSInteger)year
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear|NSCalendarUnitMonth;
    NSDateComponents *components = [calendar components:unit fromDate:[NSDate date]];
    [components setValue:year forComponent:NSCalendarUnitYear];
    [components setValue:month forComponent:NSCalendarUnitMonth];
    NSDate *date = [calendar dateFromComponents:components];
    return [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
}
#pragma mark - setup method
- (void)configureDataSource
{
    _showReloadLabelText = YES;
    _displayRowNumber = 3;
    _pageHeight = self.viewHeight / _displayRowNumber;
    _scrollViewArray = [NSMutableArray array];
    _dataArray = [NSMutableArray array];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit;

    if (_type == CustomPickerViewTypeDate) {
        unit = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
        
        NSMutableArray *yearArray = [NSMutableArray array];
        for (NSInteger year = 1900; year < 2100; year++) {
            [yearArray addObject:[NSNumber numberWithInteger:year]];
        }
        [_dataArray addObject:yearArray];
        
        NSMutableArray *monthArray = [NSMutableArray array];
        for (NSInteger month = 1; month <= 12; month++) {
            [monthArray addObject:[NSNumber numberWithInteger:month]];
        }
        [_dataArray addObject:monthArray];
        
        NSMutableArray *dayArray = [NSMutableArray array];
        for (NSInteger day = 1; day <= 31; day++) {
            [dayArray addObject:[NSNumber numberWithInteger:day]];
        }
        [_dataArray addObject:dayArray];
    }
    else if (_type == CustomPickerViewTypeTime) {
        unit = NSCalendarUnitHour|NSCalendarUnitMinute;
        NSMutableArray *hourArray = [NSMutableArray array];
        for (NSInteger hour = 0; hour < 24; hour++) {
            [hourArray addObject:[NSNumber numberWithInteger:hour]];
        }
        [_dataArray addObject:hourArray];
        
        NSMutableArray *minuteArray = [NSMutableArray array];
        for (NSInteger minute = 1; minute < 60; minute++) {
            [minuteArray addObject:[NSNumber numberWithInteger:minute]];
        }
        [_dataArray addObject:minuteArray];
    }
    _components = [calendar components:unit fromDate:[NSDate date]];
    
    _viewArray = [NSMutableArray array];
    
}

- (void)setupScrollView
{
    // scrollView的个数
    NSInteger component = _dataArray.count;
    
    NSArray *defaultArray;
    if (_type == CustomPickerViewTypeDate) {
        defaultArray = @[[NSNumber numberWithInteger:_components.year],
                                  [NSNumber numberWithInteger:_components.month],
                                  [NSNumber numberWithInteger:_components.day]];
    }
    else if (_type == CustomPickerViewTypeTime) {
        defaultArray = @[[NSNumber numberWithInteger:_components.hour],
                                  [NSNumber numberWithInteger:_components.minute]];
    }
    NSArray *timeArr = @[@"时", @"分"];
    CGFloat scrollViewX = 0;
    // 添加scrollView
    if (_scrollViewArray.count == 0) {
        for (NSInteger i = 0; i < component; i++) {
            // scrollView的宽度
            CGFloat componentWidth = (self.viewWidth-_space*(component-1))/component;
            
            UIScrollView *_scrollView = [[UIScrollView alloc] init];
            _scrollView.delegate = self;
            _scrollView.showsHorizontalScrollIndicator = NO;
            _scrollView.showsVerticalScrollIndicator = NO;
            _scrollView.frame = CGRectMake(scrollViewX, 0, componentWidth, self.viewHeight);
            _scrollView.middlePage = [_dataArray[i] indexOfObject:defaultArray[i]];
            _scrollView.currentPage = [_dataArray[i] indexOfObject:defaultArray[i]];
            [self addSubview:_scrollView];
            _scrollView.contentSize = CGSizeMake(componentWidth, (self.bounds.size.height/_displayRowNumber)*(_displayRowNumber+2));
            _scrollView.contentOffset = CGPointMake(0, (self.bounds.size.height/_displayRowNumber));
            [_scrollViewArray addObject:_scrollView];
            
            _line1 = [[UIView alloc] init];
            _line1.backgroundColor = kAPPBlueColor;
            [self addSubview:_line1];
            _line2 = [[UIView alloc] init];
            _line2.backgroundColor = kAPPBlueColor;
            [self addSubview:_line2];
            CGFloat midPageX = _pageHeight*(_displayRowNumber-1)/2;
            _line1.frame = CGRectMake(scrollViewX, midPageX - kBlueLineHeight/2, _scrollView.viewWidth, kBlueLineHeight);
            _line2.frame = CGRectMake(scrollViewX, midPageX+_pageHeight + kBlueLineHeight/2, _scrollView.viewWidth,kBlueLineHeight);
            
            NSMutableArray *labelArray = [NSMutableArray array];
            [_viewArray addObject:labelArray];
            if (_type == CustomPickerViewTypeTime) {
                UILabel *label = [[UILabel alloc] init];
                label.textColor = kAPPBlueColor;
                label.font = [UIFont systemFontOfSize:12];
                [self addSubview:label];
                label.text = timeArr[i];
                [label sizeToFit];
                label.originX = scrollViewX + componentWidth/2+12;
                label.centerY = self.viewHeight/2;
            }
            
            scrollViewX += (componentWidth+_space);
        }
    }
    
    
    
    for (NSInteger i = 0; i < _dataArray.count; i++) {
        NSMutableArray *labelArray = [_viewArray objectAtIndex:i];
        UIScrollView *scrollView = [_scrollViewArray objectAtIndex:i];
        scrollView.viewHeight = self.viewHeight;
        if (labelArray.count == 0) {
            for (NSInteger j = 0; j < 5; j++) {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, j*_pageHeight, scrollView.viewWidth, _pageHeight)];
                label.textAlignment = NSTextAlignmentCenter;
                [scrollView addSubview:label];
                [labelArray addObject:label];
                if (_type == CustomPickerViewTypeTime) {
                    label.textColor = kAPPBlueColor;
                }
                if (j != 2) {
                    label.textColor = kLineColor;
                }
                
            }
        }
    }
}

#pragma mark - Creation

- (instancetype)initWithFrame:(CGRect)frame pickerViewType:(CustomPickerViewType)type componentSpace:(CGFloat)space
{
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
        _space = space;
        self.backgroundColor = [UIColor whiteColor];
        [self configureDataSource];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setupScrollView];
//    [self reloadScrollView];
    [self reloadAllComponents];
}
#pragma mark 刷新数据
- (void)reloadComponents:(NSInteger)components
{
    if (_viewArray.count == 0 || _scrollViewArray.count == 0) {
        return;
    }
    UIScrollView *scrollView = [_scrollViewArray objectAtIndex:components];
    NSArray *labelArray = [_viewArray objectAtIndex:components];
    NSArray *pageArray = [_dataArray objectAtIndex:components];
    if (pageArray.count > 0 && labelArray.count > 0) {
        for (NSInteger j = scrollView.middlePage - (_displayRowNumber+1)/2,k = 0; j <= scrollView.middlePage + (_displayRowNumber+1)/2; j++, k++) {
            NSInteger index = [self viewIndexWithIndex:j  inComponent:components];
            NSInteger title = [[pageArray objectAtIndex:index] integerValue];
            
            UILabel *label = [labelArray objectAtIndex:k];
            if (title < 10) {
                label.text = [NSString stringWithFormat:@"0%@",@(title)];
            }
            else {
                label.text = [NSString stringWithFormat:@"%@",@(title)];
            }
        }
    }
    NSInteger title = [[pageArray objectAtIndex:scrollView.middlePage] integerValue];
    if (_type == CustomPickerViewTypeDate) {
        if (components == 0) {
            [_components setValue:title forComponent:NSCalendarUnitYear];
        }
        else if (components == 1) {
            [_components setValue:title forComponent:NSCalendarUnitMonth];
        }
        else if (components == 2) {
            [_components setValue:title forComponent:NSCalendarUnitDay];
        }
    }
    else if (_type == CustomPickerViewTypeTime) {
        if (components == 0) {
            [_components setValue:title forComponent:NSCalendarUnitHour];
        }
        else if (components == 1) {
            [_components setValue:title forComponent:NSCalendarUnitMinute];
        }
    }
}
- (void)reloadAllComponents
{
    for (NSInteger i = 0; i < _scrollViewArray.count; i++) {
        [self reloadComponents:i];
    }
}

- (void)reloadScrollView
{
    // 重新设置scrollView位置
    NSInteger component = _dataArray.count;

    CGFloat scrollViewX = 0;
    if (_scrollViewArray.count > 0) {
        for (NSInteger i = 0; i < _scrollViewArray.count; i++) {
            CGFloat componentWidth = (self.viewWidth-_space*(component-1))/component;

            UIScrollView *scrollView = [_scrollViewArray objectAtIndex:i];
            scrollView.viewHeight = self.viewHeight;
            scrollView.contentSize = CGSizeMake(componentWidth, (self.bounds.size.height/_displayRowNumber)*(_displayRowNumber+2));
            scrollView.contentOffset = CGPointMake(0, (self.bounds.size.height/_displayRowNumber));
            scrollViewX += componentWidth;
            
        }
    }
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self reloadLabelWithScrollView:scrollView];
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY >= _pageHeight*2) {
        scrollView.middlePage = [self viewIndexWithIndex:scrollView.middlePage+1 inComponent:[_scrollViewArray indexOfObject:scrollView]];
        [self reloadAllComponents];
        scrollView.contentOffset = CGPointMake(0, _pageHeight);
    }
    else if (offsetY <= 0) {
        scrollView.middlePage = [self viewIndexWithIndex:scrollView.middlePage-1 inComponent:[_scrollViewArray indexOfObject:scrollView]];
        [self reloadAllComponents];
        scrollView.contentOffset = CGPointMake(0, _pageHeight);
    }
    
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self reloadAllComponents];
    if (_type == CustomPickerViewTypeDate) {
        NSInteger days = [self numberOfDaysInCurrentMonth:_components.month year:_components.year];
        UIScrollView *dayScrollView = [_scrollViewArray objectAtIndex:_scrollViewArray.count-1];
        if (dayScrollView.middlePage > days-1) {
            dayScrollView.middlePage = days - 1;
            [self reloadComponents:2];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)kPickerValueDidChangedNotification object:self];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate == NO) {
        [self setupEndPositionWithScrollView:scrollView];
    }    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self setupEndPositionWithScrollView:scrollView];
}

#pragma mark 设置滚动结束位置
- (void)setupEndPositionWithScrollView:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY <= _pageHeight/2) {
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        scrollView.currentPage = [self viewIndexWithIndex:scrollView.middlePage - 1 inComponent:[_scrollViewArray indexOfObject:scrollView]];
    }
    else if (offsetY <= _pageHeight/2*3) {
        [scrollView setContentOffset:CGPointMake(0, _pageHeight) animated:YES];
        scrollView.currentPage = scrollView.middlePage;
    }
    else {
        [scrollView setContentOffset:CGPointMake(0, _pageHeight*2) animated:YES];
        scrollView.currentPage = [self viewIndexWithIndex:scrollView.middlePage + 1 inComponent:[_scrollViewArray indexOfObject:scrollView]];
    }
    [self reloadAllComponents];
}
#pragma mark - Help Method
- (void)reloadLabelWithScrollView:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    NSInteger index = offsetY/_pageHeight+1;
    NSInteger y = offsetY - (index-1)*_pageHeight;
    if (y > _pageHeight/2) {
        index++;
    }
    if (_viewArray.count <= 0) {
        return;
    }
    if ([_scrollViewArray containsObject:scrollView]) {
        NSArray *labelArray = [_viewArray objectAtIndex:[_scrollViewArray indexOfObject:scrollView]];
        for (NSInteger i = 0; i < labelArray.count; i++) {
            UILabel *label = [labelArray objectAtIndex:i];
            if (i == index) {
                label.textColor = [UIColor blackColor];
                if (_type == CustomPickerViewTypeTime) {
                    label.textColor = kAPPBlueColor;
                }
            }
            else {
                label.textColor = kLineColor;
            }
        }
    }
    
}
#pragma mark index转换
- (NSInteger)viewIndexWithIndex:(NSInteger)index inComponent:(NSInteger)component
{
    NSInteger totalPage = [[_dataArray objectAtIndex:component] count];
    if (index < 0) {
        index = totalPage + index;
    }
    if (index > totalPage - 1) {
        index = index - totalPage;
    }
    return index;
}
const NSString *kPickerValueDidChangedNotification = @"kPickerValueDidChangedNotification";

@end

#pragma mark - UIScrollViewExpend
static void *CircleScrollViewCurrentPageKey = (void *)@"CircleScrollViewcurrentPageKey";
static void *CircleScrollViewMiddlePageKey = (void *)@"CircleScrollViewMiddlePageKey";
@implementation UIScrollView (CircleScrollViewPicker)

- (void)setCurrentPage:(NSInteger)currentPage
{
    objc_setAssociatedObject(self, CircleScrollViewCurrentPageKey, [NSNumber numberWithInteger:currentPage], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSInteger)currentPage
{
    return [objc_getAssociatedObject(self, CircleScrollViewCurrentPageKey) integerValue];
}
- (void)setMiddlePage:(NSInteger)middlePage
{
    objc_setAssociatedObject(self, CircleScrollViewMiddlePageKey, [NSNumber numberWithInteger:middlePage], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSInteger)middlePage
{
    return [objc_getAssociatedObject(self, CircleScrollViewMiddlePageKey) integerValue];
}

@end
