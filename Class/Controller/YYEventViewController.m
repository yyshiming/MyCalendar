//
//  YYAddEventVC.m
//  MyCalendar
//
//  Created by Zsm on 15/12/16.
//  Copyright © 2015年 zhang. All rights reserved.
//

#import "YYEventViewController.h"
#import "MyEventHelper.h"

NSString *const kEventDidChangedNotification = @"EventDidChangedNotification";
@interface YYEventViewController () <UITextFieldDelegate, UIActionSheetDelegate>
{
    UITextField *_titleTF;
    UITextField *_contentTF;
}
@end

@implementation YYEventViewController

- (void)cancelAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)doneAction
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.contents) {
        [dict setValuesForKeysWithDictionary:self.contents];
    }
    
    [dict setObject:_titleTF.text forKey:kEventTitle];
    [dict setObject:self.dateString forKey:kEventDate];

    if (_contentTF.text.length > 0) {
        [dict setObject:_contentTF.text forKey:kEventContent];
    }
    else {
        [dict setObject:@"" forKey:kEventContent];
    }
    [[MyEventHelper sharedEvent] addEventWithContents:dict];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kEventDidChangedNotification object:nil];
    
    [self cancelAction];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([_titleTF isFirstResponder]) {
        [_titleTF resignFirstResponder];
    }
    if ([_contentTF isFirstResponder]) {
        [_contentTF resignFirstResponder];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.eventState == EventStateAdd) {
        self.navigationItem.title = @"新建事件";
    }
    else {
        self.navigationItem.title = @"编辑事件";
    }
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    rightItem.enabled = NO;
    
    _titleTF = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, self.view.viewWidth-30, 44)];
    _titleTF.placeholder = @"标题";
    _titleTF.delegate = self;
    [_titleTF addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventEditingChanged];
    
    _contentTF = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, self.view.viewWidth-30, 44)];
    _contentTF.placeholder = @"内容";
    [_contentTF addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventEditingChanged];
    _contentTF.delegate = self;
    
    if (self.contents) {
        _titleTF.text = self.contents[@"event_title"];
        _contentTF.text = self.contents[@"event_content"];
        self.dateString = self.contents[@"event_date"];
    }
    
    if (self.eventState == EventStateEdit) {
        self.tableView.viewHeight = kScreenHeight - 64 - 49;
        UITabBar *tabBar = [[UITabBar alloc] initWithFrame:CGRectMake(0, self.tableView.maxY, self.view.viewWidth, 49)];
        [self.view addSubview:tabBar];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:@"删除事件" forState:UIControlStateNormal];
        [button setTitleColor:kAPPBlueColor forState:UIControlStateNormal];
        button.frame = tabBar.bounds;
        [tabBar addSubview:button];
        [button addTarget:self action:@selector(deleteButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)deleteEvent
{
    [[MyEventHelper sharedEvent] removeEventWithContents:self.contents];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kEventDidChangedNotification object:nil];
    [self cancelAction];
}
- (void)deleteButtonAction
{
    if (kDeviceSystemVersion >= 8.0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"删除事件" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self deleteEvent];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else {
        UIActionSheet *actonSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除事件" otherButtonTitles:nil, nil];
        [actonSheet showInView:self.view];
    }
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self deleteEvent];
    }
}
- (void)valueChanged:(UITextField *)textField
{
    if (textField == _titleTF && textField.text.length == 0) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    else {
        if (self.contents) {
            NSString *title = self.contents[@"event_title"];
            NSString *content = self.contents[@"event_content"];
            if ([title isEqualToString:_titleTF.text] &&
                [content isEqualToString:_contentTF.text]) {
                self.navigationItem.rightBarButtonItem.enabled = NO;
            }
            else {
                self.navigationItem.rightBarButtonItem.enabled = YES;
            }
        }
        else {
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
    }
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
    }
    if (indexPath.row == 0) {
        [cell.contentView addSubview:_titleTF];
    }
    else if (indexPath.row == 1) {
        [cell.contentView addSubview:_contentTF];
    }
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
@end
