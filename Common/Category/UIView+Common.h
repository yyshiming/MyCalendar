//
//  UIView+Common.h
//  KDBCommon
//
//  Created by YY on 15/7/1.
//  Copyright (c) 2015年 YY. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kNSLayoutConstraints
@interface UIView (Common)

@property (assign, nonatomic) CGFloat originX;
@property (assign, nonatomic) CGFloat originY;
@property (assign, nonatomic) CGFloat centerX;
@property (assign, nonatomic) CGFloat centerY;
@property (assign, nonatomic) CGFloat viewWidth;
@property (assign, nonatomic) CGFloat viewHeight;

@property (readonly, nonatomic) CGFloat maxX;
@property (readonly, nonatomic) CGFloat maxY;

- (void)removeAllSubViews;

#ifdef kNSLayoutConstraints
// NSLayoutConstraints
@property (assign, nonatomic) BOOL shouldAddConstraints;
// 相对于superview
@property (assign, nonatomic) CGFloat leftMargin;
@property (assign, nonatomic) CGFloat rightMargin;
@property (assign, nonatomic) CGFloat topMargin;
@property (assign, nonatomic) CGFloat bottomMargin;

@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;
@property (assign, nonatomic) CGFloat widthLessThanOrEqual;
@property (assign, nonatomic) CGFloat heightLessThanOrEqual;
@property (assign, nonatomic) CGFloat widthGreaterThanOrEqual;
@property (assign, nonatomic) CGFloat heightGreaterThanOrEqual;


- (void)equalWidthToView:(UIView *)view;
- (void)equalHeightToView:(UIView *)view;
- (void)equalSizeToView:(UIView *)view;

- (void)multiplierWidth:(CGFloat)multiplier toView:(UIView *)view;
- (void)multiplierHeight:(CGFloat)multiplier toView:(UIView *)view;
- (void)multiplierSize:(CGFloat)multiplier toView:(UIView *)view;

- (void)alignTopToView:(UIView *)view;
- (void)alignLeadingToView:(UIView *)view;
- (void)alignBottomToView:(UIView *)view;
- (void)alignTrailingToView:(UIView *)view;
- (void)alignCenterXToView:(UIView *)view;
- (void)alignCenterYToView:(UIView *)view;

- (void)leadingToTrailingConstraint:(CGFloat)constraint withView:(UIView *)view;
#endif

@end
