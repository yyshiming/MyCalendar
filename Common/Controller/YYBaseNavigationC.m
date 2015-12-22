//
//  BaseNavigationController.m
//  KDBCommon
//
//  Created by YY on 15/7/1.
//  Copyright (c) 2015年 YY. All rights reserved.
//

#import "YYBaseNavigationC.h"

@interface YYBaseNavigationC ()

@end

@implementation YYBaseNavigationC

- (void)appColorDidChanged
{
    UIColor *color = [YYConfigure colorForKey:kDefaultAppColorKey];
    [self.navigationBar setBarTintColor:color];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appColorDidChanged) name:kAppColorDidChangedNotification object:nil];
    
    UIColor *color = [YYConfigure colorForKey:kDefaultAppColorKey];
    // 导航栏背景
    [[UINavigationBar appearance] setBarTintColor:color];

    
    // 返回按钮颜色
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
//    [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
    
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
