//
//  PickerView.m
//  KDBCommon
//
//  Created by 张世明 on 15/8/4.
//  Copyright (c) 2015年 张世明. All rights reserved.
//

#import "PickerView.h"

#define kSpace 60
#define kHeight 250
#define kTopViewHeight 35
#define kBottomViewHeight 50
@implementation PickerView {
    UIView *_backgroundView;
    ButtonClickBlock _block;
}
- (instancetype)initWithType:(CustomPickerViewType)type clickButtonIndexBlock:(void (^)(CustomPickerView *, NSInteger))block
{
    self = [super init];
    if (self) {
        self.frame = [[UIScreen mainScreen] bounds];
        self.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.3];
        
        _block = block;
        CGFloat space = 0;
        if (type == CustomPickerViewTypeDate) {
            space = 20;
        }
        
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(kSpace, 0, [[UIScreen mainScreen] bounds].size.width-kSpace*2, [UIScreen mainScreen].bounds.size.height/3)];
        _backgroundView.backgroundColor = [UIColor whiteColor];
        _backgroundView.layer.cornerRadius = 3.0;
        _backgroundView.clipsToBounds = YES;
        _backgroundView.centerY = [[UIScreen mainScreen] bounds].size.height/2;
        [self addSubview:_backgroundView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _backgroundView.viewWidth, kTopViewHeight)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:15];
        if (type == CustomPickerViewTypeDate) {
            titleLabel.text = @"选择日期";
        }
        else if (type == CustomPickerViewTypeTime) {
            titleLabel.text = @"选择时间";
        }
        [_backgroundView addSubview:titleLabel];
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, titleLabel.maxY, _backgroundView.viewWidth, kLineHeight)];
        line1.backgroundColor = kLineColor;
        [_backgroundView addSubview:line1];
        
        CGFloat pickerSpace = 40;
        self.pickerView = [[CustomPickerView alloc] initWithFrame:CGRectMake(pickerSpace, line1.maxY, _backgroundView.viewWidth-pickerSpace*2, _backgroundView.viewHeight-kTopViewHeight-kBottomViewHeight-kLineHeight*2) pickerViewType:type componentSpace:space];
        [_backgroundView addSubview:self.pickerView];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, self.pickerView.maxY, _backgroundView.viewWidth, kLineHeight)];
        line2.backgroundColor = kLineColor;
        [_backgroundView addSubview:line2];
        
        CGFloat buttonHeight = 30;
        CGFloat buttonSpace = 30;
        CGFloat buttonWidth = (_backgroundView.viewWidth - buttonSpace*3)/2;
        UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancleButton setTitleColor:kAPPBlueColor forState:UIControlStateNormal];
        [cancleButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [cancleButton.layer setBorderColor:[kAPPBlueColor CGColor]];
        [cancleButton.layer setBorderWidth:kLineHeight];
        [cancleButton.layer setCornerRadius:3.0];
        [cancleButton setClipsToBounds:YES];
        [cancleButton setTag:0];
        [cancleButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cancleButton setFrame:CGRectMake(buttonSpace, line2.maxY+(kBottomViewHeight-buttonHeight)/2, buttonWidth, buttonHeight)];
        [_backgroundView addSubview:cancleButton];
        
        UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [confirmButton setBackgroundColor:kAPPBlueColor];
        [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [confirmButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [confirmButton.layer setBorderColor:[kAPPBlueColor CGColor]];
        [confirmButton.layer setBorderWidth:kLineHeight];
        [confirmButton.layer setCornerRadius:3.0];
        [confirmButton setClipsToBounds:YES];
        [confirmButton setTag:1];
        [confirmButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [confirmButton setFrame:CGRectMake(buttonSpace+cancleButton.maxX, cancleButton.originY, buttonWidth, buttonHeight)];
        [_backgroundView addSubview:confirmButton];
        
    }
    return self;
}
- (void)buttonClicked:(UIButton *)sender
{
    _block(self.pickerView, sender.tag);
    [self hide];
}
- (void)show
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
}
- (void)hide
{
    [self removeFromSuperview];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hide];
}
@end
