//
//  CustomPopoverView1.h
//  KDBCommon
//
//  Created by 张世明 on 15/7/3.
//  Copyright (c) 2015年 张世明. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, CustomPopoverArrowDirection) {
    CustomPopoverArrowDirectionUp = 1UL << 0,
    CustomPopoverArrowDirectionDown = 1UL << 1,
    CustomPopoverArrowDirectionUnknown = NSUIntegerMax
};
@interface CustomPopoverView : UIView

@property (readonly, nonatomic) CGFloat cornerRadius;

@property (assign, nonatomic) CGSize contentSize;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIColor *contentBackgroundColor;
@property (assign, nonatomic) CustomPopoverArrowDirection popoverArrowDirection;
@property (readonly, nonatomic) BOOL isPopoverVisible;


- (void)showPopoverFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated;
- (void)showPopoverFromRect:(CGRect)rect animated:(BOOL)animated;

@end


