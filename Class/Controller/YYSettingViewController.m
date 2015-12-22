//
//  YYSettingViewController.m
//  MyCalendar
//
//  Created by Zsm on 15/12/22.
//  Copyright © 2015年 zhang. All rights reserved.
//

#import "YYSettingViewController.h"
#import "YYColorSetViewController.h"

@interface YYSettingViewController ()

@end

@implementation YYSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"设置";
    
    [self.dataArray addObjectsFromArray:@[@"主题颜色"]];
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
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        YYColorSetViewController *colorSetVC = [[YYColorSetViewController alloc] init];
        colorSetVC.navigationItem.title = self.dataArray[indexPath.row];
        [self.navigationController pushViewController:colorSetVC animated:YES];
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
