//
//  CircleScrollView1.h
//  KDBCommon
//
//  Created by 张世明 on 15/7/24.
//  Copyright (c) 2015年 张世明. All rights reserved.
//

#import <UIKit/UIKit.h>


#define kLineHeight 0.5
#define kBlueLineHeight 1
#define kLineColor [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.7]
extern NSString *kPickerValueDidChangedNotification;
typedef NS_ENUM(NSInteger, CustomPickerViewType) {
    CustomPickerViewTypeDate,
    CustomPickerViewTypeTime
};


@interface CustomPickerView : UIView

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *dateString;
- (instancetype)initWithFrame:(CGRect)frame pickerViewType:(CustomPickerViewType)type componentSpace:(CGFloat)space;

@end


@interface UIScrollView (CircleScrollViewPicker)

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger middlePage;

@end