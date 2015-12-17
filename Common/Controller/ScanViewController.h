//
//  ScanViewController.h
//  KDBCommon
//
//  Created by YY on 15/7/6.
//  Copyright (c) 2015年 YY. All rights reserved.
//

#import "YYBaseViewController.h"

typedef NS_ENUM(NSInteger, ScanType){
    ScanTypeDefault = 0,  // 所有
    ScanTypeQRCode,   // 二维码
    ScanTypeBarCode,  // 条形码
};
@interface ScanViewController : YYBaseViewController

@property (nonatomic, assign) ScanType scanType;
@property (atomic, readonly) BOOL isReading;

- (BOOL)setupCaptureSession;
- (BOOL)resetCaptureSession;
- (void)startCaptureSession;
- (void)stopCaptureSession;

@end
