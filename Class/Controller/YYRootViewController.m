//
//  ViewController.m
//  MyCalendar
//
//  Created by Zsm on 15/12/16.
//  Copyright © 2015年 zhang. All rights reserved.
//

#import "YYRootViewController.h"
#import "MyCalenderView.h"
#import "MyEventHelper.h"
#import "YYEventViewController.h"
#import "PickerView.h"

#define kWeekViewHeight 20
@interface YYRootViewController ()<MyCalendarViewDelegate, UIScrollViewDelegate>
{
    MyCalenderView *_calenderView1;
    MyCalenderView *_calenderView2;
    MyCalenderView *_calenderView3;
    UIButton *_timeButton;
    
    PickerView *_pickerView;
    
    UIView *_weekTitleView;
}

@property (nonatomic, strong) NSDate *currentDate;

@end

@implementation YYRootViewController

- (void)setCurrentDate:(NSDate *)currentDate
{
    _currentDate = currentDate;
    
    _calenderView2.selectedDate = currentDate;
    
    _calenderView1.selectedDate = [currentDate firstDateOfPreviousMonth];
    
    _calenderView3.selectedDate = [currentDate firstDateOfNextMonth];
    
}
- (void)addAction
{
    YYEventViewController *addEvent = [[YYEventViewController alloc] init];
    addEvent.dateString = _calenderView2.dateString;
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:addEvent];
    [self presentViewController:navC animated:YES completion:nil];
}
- (void)reloadEventList
{
    [self.tableView reloadData];
}
- (void)tapAction
{
    if (_pickerView == nil) {
        _pickerView = [[PickerView alloc] initWithType:CustomPickerViewTypeDate clickButtonIndexBlock:^(CustomPickerView *pickerView, NSInteger index) {
            if (index == 1) {
                self.currentDate = pickerView.date;
                [self reloadLabel];
            }
        }];
    }
    [_pickerView.pickerView setDate:_calenderView2.selectedDate];
    [_pickerView show];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kEventDidChangedNotification object:nil];
}
- (void)timeButtonSetText:(NSString *)text
{
    NSArray *stirngs = [text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSRange range1 = [text rangeOfString:stirngs[0]];
    NSRange range2 = [text rangeOfString:stirngs[1]];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *attrs = @{NSParagraphStyleAttributeName: paragraphStyle};
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:text attributes:attrs];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:range1];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:range2];
    
    [_timeButton setAttributedTitle:attributedStr forState:UIControlStateNormal];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.navigationItem.title = @"日历";
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"今" style:UIBarButtonItemStylePlain target:self action:@selector(today)];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAction)];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _timeButton.frame = CGRectMake(0, 0, self.view.viewWidth/3, 40);
    _timeButton.titleLabel.numberOfLines = 2;
    [_timeButton addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = _timeButton;
    
    NSArray *weeklyArray = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    _weekTitleView = [[UIView alloc] init];
    _weekTitleView.frame = CGRectMake(0, 10, self.view.viewWidth, kWeekViewHeight);
    [self.view addSubview:_weekTitleView];
    
    CGFloat buttonWidth = _weekTitleView.viewWidth/weeklyArray.count;
    for (NSInteger i = 0; i < weeklyArray.count; i++) {
        CGRect labelFrame = CGRectMake(buttonWidth*i, 0, buttonWidth, _weekTitleView.viewHeight);
        UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
        label.text = weeklyArray[i];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor lightGrayColor];
        label.textAlignment = NSTextAlignmentCenter;
        [_weekTitleView addSubview:label];
    }
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _weekTitleView.maxY, self.view.viewWidth, 300)];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    _calenderView1 = [[MyCalenderView alloc] initWithFrame:CGRectMake(0, 0, scrollView.viewWidth, scrollView.viewHeight)];
    _calenderView1.delegate = self;
    [scrollView addSubview:_calenderView1];
    
    _calenderView2 = [[MyCalenderView alloc] initWithFrame:CGRectMake(_calenderView1.maxX, 0, scrollView.viewWidth, scrollView.viewHeight)];
    _calenderView2.delegate = self;
    [scrollView addSubview:_calenderView2];
    
    _calenderView3 = [[MyCalenderView alloc] initWithFrame:CGRectMake(_calenderView2.maxX, 0, scrollView.viewWidth, scrollView.viewHeight)];
    _calenderView3.delegate = self;
    [scrollView addSubview:_calenderView3];
    
    self.currentDate = [NSDate date];
    scrollView.contentSize = CGSizeMake(scrollView.viewWidth*3, scrollView.viewHeight);
    [scrollView scrollRectToVisible:CGRectMake(scrollView.viewWidth, 0, scrollView.viewWidth, scrollView.viewHeight) animated:NO];
    
    [self reloadLabel];
    
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, scrollView.maxY, self.view.viewWidth, kScreenHeight - 64 - scrollView.maxY);
}

- (void)reloadLabel
{
    NSString *text = [NSString stringWithFormat:@"%@\n%@", _calenderView2.dateString, _calenderView2.chineseDateString];
    [self timeButtonSetText:text];
    [self.tableView reloadData];
}

- (void)today
{
    self.currentDate = [NSDate date];
    
    [self reloadLabel];
}

- (void)calendarView:(MyCalenderView *)gridView didSelectDate:(NSDate *)date
{
    [self reloadLabel];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITabelViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentity = @"cellIdentities";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentity];
    }
    NSArray *events = [[MyEventHelper sharedEvent] eventsWithDate:_calenderView2.dateString];
    NSDictionary *dict = [events objectAtIndex:indexPath.row];
    
    cell.textLabel.text = dict[kEventTitle];
    cell.detailTextLabel.text = dict[kEventContent];
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[MyEventHelper sharedEvent] eventsWithDate:_calenderView2.dateString] count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *events = [[MyEventHelper sharedEvent] eventsWithDate:_calenderView2.dateString];
    NSDictionary *dict = [events objectAtIndex:indexPath.row];
    
    YYEventViewController *eventVC = [[YYEventViewController alloc] init];
    eventVC.eventState = EventStateEdit;
    eventVC.contents = dict;
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:eventVC];
    [self presentViewController:navC animated:YES completion:nil];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        return;
    }
    
    CGFloat offset = scrollView.contentOffset.x;
    if (offset == 0) {
        NSDate *newDate = [self.currentDate firstDateOfPreviousMonth];
        self.currentDate = newDate;
        [self reloadLabel];
        [scrollView scrollRectToVisible:CGRectMake(scrollView.viewWidth, 0, scrollView.viewWidth, scrollView.viewHeight) animated:NO];
    }
    else if (offset == scrollView.viewWidth*2) {
        NSDate *newDate = [self.currentDate firstDateOfNextMonth];
        self.currentDate = newDate;
        [self reloadLabel];
        [scrollView scrollRectToVisible:CGRectMake(scrollView.viewWidth, 0, scrollView.viewWidth, scrollView.viewHeight) animated:NO];
    }

}
@end
