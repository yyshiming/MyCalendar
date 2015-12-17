//
//  PickerView.h
//  KDBCommon
//
//  Created by 张世明 on 15/8/4.
//  Copyright (c) 2015年 张世明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPickerView.h"

typedef void(^ButtonClickBlock)(CustomPickerView *pickerView, NSInteger index);
@interface PickerView : UIView

@property (nonatomic, strong) CustomPickerView *pickerView;
- (instancetype)initWithType:(CustomPickerViewType)type clickButtonIndexBlock:(void(^)(CustomPickerView *pickerView, NSInteger index))block;
- (void)show;

@end
