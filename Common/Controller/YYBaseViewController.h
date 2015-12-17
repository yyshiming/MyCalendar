//
//  BaseViewController.h
//  KDBCommon
//
//  Created by YY on 15/7/1.
//  Copyright (c) 2015年 YY. All rights reserved.
//

#import <UIKit/UIKit.h>

// viewDidLoad -->
// viewWillAppear -->
// viewWillLayoutSubviews -->
// viewDidLayoutSubviews -->
// viewDidAppear
#define kDeviceSystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]
@interface YYBaseViewController : UIViewController

- (void)showImagePickerActionSheet;

@end
