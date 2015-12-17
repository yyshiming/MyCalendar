//
//  UIView+Common.m
//  KDBCommon
//
//  Created by YY on 15/7/1.
//  Copyright (c) 2015年 YY. All rights reserved.
//

#import "UIView+Common.h"

//#define kLayoutConstraintType
@implementation UIView (Common)
#ifdef kNSLayoutConstraints
@dynamic leftMargin, rightMargin, topMargin, bottomMargin, width, height, widthGreaterThanOrEqual, heightGreaterThanOrEqual, widthLessThanOrEqual, heightLessThanOrEqual, shouldAddConstraints;
#endif
#pragma mark - getter
- (CGFloat)originX
{
    return CGRectGetMinX(self.frame);
}
- (CGFloat)originY
{
    return CGRectGetMinY(self.frame);
}
- (CGFloat)centerX
{
    return CGRectGetMidX(self.frame);
}
- (CGFloat)centerY
{
    return CGRectGetMidY(self.frame);
}
- (CGFloat)maxX
{
    return CGRectGetMaxX(self.frame);
}
- (CGFloat)maxY
{
    return CGRectGetMaxY(self.frame);
}
- (CGFloat)viewWidth
{
    return CGRectGetWidth(self.frame);
}
- (CGFloat)viewHeight
{
    return CGRectGetHeight(self.frame);
}
// 坐标位置
#pragma mark - setter
- (void)setOriginX:(CGFloat)originX
{
    CGRect selfFrame = self.frame;
    selfFrame.origin.x = originX;
    self.frame = selfFrame;
}
- (void)setOriginY:(CGFloat)originY
{
    CGRect selfFrame = self.frame;
    selfFrame.origin.y = originY;
    self.frame = selfFrame;
}
- (void)setCenterX:(CGFloat)centerX
{
    CGPoint selfCenter = self.center;
    selfCenter.x = centerX;
    self.center = selfCenter;
}
- (void)setCenterY:(CGFloat)centerY
{
    CGPoint selfCenter = self.center;
    selfCenter.y = centerY;
    self.center = selfCenter;
}
- (void)setViewWidth:(CGFloat)viewWidth
{
    CGRect selfFrame = self.frame;
    selfFrame.size.width = viewWidth;
    self.frame = selfFrame;
}
- (void)setViewHeight:(CGFloat)viewHeight
{
    CGRect selfFrame = self.frame;
    selfFrame.size.height = viewHeight;
    self.frame = selfFrame;
}

- (void)removeAllSubViews
{
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
}
// NSlayoutConstraint
- (void)setShouldAddConstraints:(BOOL)shouldAddConstraints
{
    [self setTranslatesAutoresizingMaskIntoConstraints:!shouldAddConstraints];
}
- (void)setLeftMargin:(CGFloat)leftMargin
{
#ifdef kLayoutConstraintType
    NSDictionary *views = NSDictionaryOfVariableBindings(self);
    NSDictionary *metrics = @{@"leftMargin": @(leftMargin)};
    NSString *format = @"H:|-leftMargin-[self]";
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:metrics views:views];
    [self.superview addConstraints:constraints];
#else
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeLeft multiplier:1 constant:leftMargin];
    [self.superview addConstraint:constraint];
#endif
}
- (void)setRightMargin:(CGFloat)rightMargin
{
#ifdef kLayoutConstraintType
    NSDictionary *views = NSDictionaryOfVariableBindings(self);
    NSDictionary *metrics = @{@"rightMargin": @(rightMargin)};
    NSString *format = @"H:[self]-rightMargin-|";
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:metrics views:views];
    [self.superview addConstraints:constraints];
#else
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeRight multiplier:1 constant:-rightMargin];
    [self.superview addConstraint:constraint];
#endif
}
- (void)setTopMargin:(CGFloat)topMargin
{
#ifdef kLayoutConstraintType
    NSDictionary *views = NSDictionaryOfVariableBindings(self,self.superview);
    NSDictionary *metrics = @{@"topMargin": @(topMargin)};
    NSString *format = @"V:|-topMargin-[self]";
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:metrics views:views];
    [self.superview addConstraints:constraints];
#else
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeTop multiplier:1 constant:topMargin];
    [self.superview addConstraint:constraint];
#endif
}
- (void)setBottomMargin:(CGFloat)bottomMargin
{
#ifdef kLayoutConstraintType
    NSDictionary *views = NSDictionaryOfVariableBindings(self,self.superview);
    NSDictionary *metrics = @{@"bottomMargin": @(bottomMargin)};
    NSString *format = @"V:[self]-bottomMargin-|";
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:metrics views:views];
    [self.superview addConstraints:constraints];
#else
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeBottom multiplier:1 constant:-bottomMargin];
    [self.superview addConstraint:constraint];
#endif
}
- (void)setWidth:(CGFloat)width
{
#ifdef kLayoutConstraintType
    NSDictionary *views = NSDictionaryOfVariableBindings(self,self.superview);
    NSDictionary *metrics = @{@"w": @(width)};
    NSString *format = @"H:[self(w)]";
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:metrics views:views];
    [self.superview addConstraints:constraints];
#else
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:width];
    [self.superview addConstraint:constraint];
#endif
}
- (void)setHeight:(CGFloat)height
{
#ifdef kLayoutConstraintType
    NSDictionary *views = NSDictionaryOfVariableBindings(self,self.superview);
    NSDictionary *metrics = @{@"h": @(height)};
    NSString *format = @"V:[self(h)]";
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:metrics views:views];
    [self.superview addConstraints:constraints];
#else
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:height];
    [self.superview addConstraint:constraint];
#endif
}
- (void)setWidthLessThanOrEqual:(CGFloat)widthLessThanOrEqual
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:widthLessThanOrEqual];
    [self.superview addConstraint:constraint];
}
- (void)setHeightLessThanOrEqual:(CGFloat)heightLessThanOrEqual
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:heightLessThanOrEqual];
    [self.superview addConstraint:constraint];
}
- (void)setWidthGreaterThanOrEqual:(CGFloat)widthGreaterThanOrEqual
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:widthGreaterThanOrEqual];
    [self.superview addConstraint:constraint];
}
- (void)setHeightGreaterThanOrEqual:(CGFloat)heightGreaterThanOrEqual
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:heightGreaterThanOrEqual];
    [self.superview addConstraint:constraint];
}
- (void)equalWidthToView:(UIView *)view
{
#ifdef kLayoutConstraintType
    NSDictionary *views = NSDictionaryOfVariableBindings(self,view);
    NSString *format = @"H:[self(view)]";
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views];
    [self.superview addConstraints:constraints];
#else
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    [self.superview addConstraint:constraint];
#endif
}
- (void)equalHeightToView:(UIView *)view
{
#ifdef kLayoutConstraintType
    NSDictionary *views = NSDictionaryOfVariableBindings(self,view);
    NSString *format = @"V:[self(view)]";
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views];
    [self.superview addConstraints:constraints];
#else
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
    [self.superview addConstraint:constraint];
#endif
}
- (void)equalSizeToView:(UIView *)view
{
    [self equalWidthToView:view];
    [self equalHeightToView:view];
}
- (void)multiplierWidth:(CGFloat)multiplier toView:(UIView *)view
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:multiplier constant:0];
    [self.superview addConstraint:constraint];
}
- (void)multiplierHeight:(CGFloat)multiplier toView:(UIView *)view
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeHeight multiplier:multiplier constant:0];
    [self.superview addConstraint:constraint];
}
- (void)multiplierSize:(CGFloat)multiplier toView:(UIView *)view
{
    [self multiplierWidth:multiplier toView:view];
    [self multiplierHeight:multiplier toView:view];
}
- (void)alignTopToView:(UIView *)view
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    [self.superview addConstraint:constraint];
}
- (void)alignLeadingToView:(UIView *)view
{    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    [self.superview addConstraint:constraint];
}
- (void)alignBottomToView:(UIView *)view
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    [self.superview addConstraint:constraint];
}
- (void)alignTrailingToView:(UIView *)view
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    [self.superview addConstraint:constraint];
}
- (void)alignCenterXToView:(UIView *)view
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    [self.superview addConstraint:constraint];
}
- (void)alignCenterYToView:(UIView *)view
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [self.superview addConstraint:constraint];
}
- (void)leadingToTrailingConstraint:(CGFloat)constraint withView:(UIView *)view
{
    NSLayoutConstraint *layoutConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTrailing multiplier:1 constant:constraint];
    [self.superview addConstraint:layoutConstraint];
}
@end
