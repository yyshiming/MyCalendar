//
//  BaseTableVC.m
//  KDBCommon
//
//  Created by YY on 15/7/1.
//  Copyright (c) 2015年 YY. All rights reserved.
//

#import "YYBaseTableVC.h"

@interface YYBaseTableVC ()

@end

@implementation YYBaseTableVC
#pragma mark - UIKeyboardShowAndHide Method
- (void)keyboardWillShow:(NSNotification *)sender
{
    NSTimeInterval duration = [[sender.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGSize size = [[sender.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    if (size.height > 0) {
        [UIView animateWithDuration:duration animations:^{
            self.tableView.viewHeight = self.view.viewHeight - size.height;
        }];
    }
}
- (void)keyboardWillHide:(NSNotification *)sender
{
    NSTimeInterval duration = [[sender.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
//    CGSize size = [[sender.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:duration animations:^{
        self.tableView.viewHeight = self.view.viewHeight;
    }];
}
#pragma mark - lift circle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
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
    return 0;
}

#pragma mark - getter method

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), kScreenHeight - 64) style:UITableViewStylePlain];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setTableFooterView:[UIView new]];
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
@end
