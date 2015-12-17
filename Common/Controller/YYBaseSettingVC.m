//
//  BaseSettingVC.m
//  KDBCommon
//
//  Created by YY on 15/7/2.
//  Copyright (c) 2015年 YY. All rights reserved.
//

#import "YYBaseSettingVC.h"

@interface YYBaseSettingVC ()

@end

@implementation YYBaseSettingVC

#pragma mark - lift circle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
}
#pragma mark - UITabelViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentity = @"cellIdentities";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
    }
    
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

#pragma mark - getter method

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        //        [_tableView setTableFooterView:[UIView new]];
    }
    return _tableView;
}
- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
#pragma mark - setter method

- (void)setTableViewHeaderView:(UIView *)tableViewHeaderView
{
    if (_tableViewHeaderView != tableViewHeaderView) {
        _tableViewHeaderView = tableViewHeaderView;
    }
    
    self.tableView.tableHeaderView = tableViewHeaderView;
}
- (void)setTableViewFooterView:(UIView *)tableViewFooterView
{
    if (_tableViewFooterView != tableViewFooterView) {
        _tableViewFooterView = tableViewFooterView;
    }
    
    self.tableView.tableFooterView = tableViewFooterView;
}
@end
