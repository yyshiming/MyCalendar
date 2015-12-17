//
//  BaseScrollVC.m
//  KDBCommon
//
//  Created by YY on 15/7/1.
//  Copyright (c) 2015年 YY. All rights reserved.
//

#import "YYBaseScrollVC.h"

@interface YYBaseScrollVC ()

@end
@implementation YYBaseScrollVC

#pragma mark - UIKeyboardShowAndHide Method
- (void)keyboardWillShow:(NSNotification *)sender
{
    NSTimeInterval duration = [[sender.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGSize size = [[sender.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    if (size.height > 0) {
        [UIView animateWithDuration:duration animations:^{
            self.scrollView.viewHeight = self.view.viewHeight - size.height;
        }];
    }
}
- (void)keyboardWillHide:(NSNotification *)sender
{
    NSTimeInterval duration = [[sender.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
//    CGSize size = [[sender.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:duration animations:^{
        self.scrollView.viewHeight = self.view.viewHeight;
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
    
    [self.view addSubview:self.scrollView];
    
}

#pragma mark - getter method
- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), kScreenHeight - 64)];
        [_scrollView setAlwaysBounceVertical:YES];
        [_scrollView setDelegate:self];
    }
    return _scrollView;
}
#pragma mark - setter method

@end
