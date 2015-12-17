//
//  BaseSettingVC.h
//  KDBCommon
//
//  Created by YY on 15/7/2.
//  Copyright (c) 2015年 YY. All rights reserved.
//

#import "YYBaseViewController.h"

@interface YYBaseSettingVC : YYBaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) UIView *tableViewHeaderView;
@property (strong, nonatomic) UIView *tableViewFooterView;


@end
