//
//  CustomPopoverView.m
//  KDBCommon
//
//  Created by 张世明 on 15/7/2.
//  Copyright (c) 2015年 张世明. All rights reserved.
//

#import "CustomPopoverView.h"

//#define kTest
#define kUsingSpringWithDamping

#define kShadowOffset 2.0
#define kCornerRadiusDefault 5.0
#define kArrowHeightDefault  10
#define kArrowWidthDefault 20  
#define kPadding 3  // contentview边缘靠近屏幕边缘时的空隙
#define kAnimationDuration 0.25
#define kBackgroundColorDefault [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.7]

#ifndef kScreenWidth
    #define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#endif

#ifndef kScreenHeight
    #define kScreenHeight [[UIScreen mainScreen] bounds].size.height
#endif

@interface ContentView : UIView
{
    CGFloat _arrowWidth;
    CGFloat _arrowHeight;
    CGPoint _arrowPoint;
    
    CGPoint _leftUpPoint;
    CGPoint _leftDownPoint;
    CGPoint _rightDownPoint;
    CGPoint _rightUpPoint;
}
@property (assign, nonatomic) CustomPopoverArrowDirection popoverArrowDirection;
@property (assign, nonatomic) CGFloat cornerRadius;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIColor *lineColor;
@property (strong, nonatomic) UIColor *contentBackgroudColor;

- (instancetype)initWithArrowPoint:(CGPoint)arrowPoint;

@end
@interface CustomPopoverView () <UIGestureRecognizerDelegate>
{
    ContentView *_contentBackgroundView;
    CGRect _showRect;
    
    CGPoint _arrowPoint;
    CGFloat _arrowWidth;
    CGFloat _arrowHeight;
    
    BOOL _animated;
    UIView *_theSuperview;
    UIColor *_lineColor;
}
@end
@implementation CustomPopoverView

- (void)setupDefaultValue
{
    self.backgroundColor = kBackgroundColorDefault;
    _contentView = [[UIView alloc] init];
    [self addSubview:_contentView];
    _lineColor = [UIColor clearColor];

    _popoverArrowDirection = CustomPopoverArrowDirectionUp;
    _cornerRadius = kCornerRadiusDefault;
    _arrowHeight = kArrowHeightDefault;
    _arrowWidth = kArrowWidthDefault;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"init");
        [self setupDefaultValue];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"initWithFrame");
        [self setupDefaultValue];
    }
    return self;
}
- (void)tapAction:(UITapGestureRecognizer *)sender
{
    [self removeFromSuperview];
    _isPopoverVisible = NO;
}
- (void)showPopoverFromRect:(CGRect)rect animated:(BOOL)animated
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [self showPopoverFromRect:rect inView:window animated:animated];
}
- (void)showPopoverFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated
{
    _theSuperview = view;
    _showRect = [self convertRect:rect toView:self];
    _animated = animated;
    [self setupContentView];
    
    
    self.frame = view.bounds;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tapGesture.delegate = self;
    [self addGestureRecognizer:tapGesture];
    [view addSubview:self];
    _isPopoverVisible = YES;
}
- (void)setupContentView
{
    CGSize contentSize = CGSizeMake(_contentSize.width + kShadowOffset * 2,
                              _contentSize.height + _arrowHeight + kShadowOffset);
    CGFloat x = CGRectGetMidX(_showRect) - contentSize.width/2;
    if (contentSize.width > _theSuperview.viewWidth - kPadding * 2) {
        contentSize.width = _theSuperview.viewWidth - kPadding * 2;
        x = kPadding;
    }
    CGFloat y = CGRectGetMaxY(_showRect);
    
    switch (_popoverArrowDirection) {
        case CustomPopoverArrowDirectionUp:
        {
            if (contentSize.height + CGRectGetMaxY(_showRect) > _theSuperview.viewHeight - kPadding) {
                contentSize.height = _theSuperview.viewHeight - kPadding - CGRectGetMaxY(_showRect);
            }
            y = CGRectGetMaxY(_showRect);
            _arrowPoint = CGPointMake(CGRectGetMidX(_showRect), CGRectGetMaxY(_showRect));
            
        }
            break;
        case CustomPopoverArrowDirectionDown:
        {
            if (CGRectGetMinY(_showRect) - contentSize.height < kPadding) {
                contentSize.height = CGRectGetMinY(_showRect) - kPadding;
                y = kPadding;
            }
            y = CGRectGetMinY(_showRect) - contentSize.height;
            _arrowPoint = CGPointMake(CGRectGetMidX(_showRect), CGRectGetMinY(_showRect));
        }
            break;
        default:
            break;
    }
    
    
    // 右侧边缘
    if (_arrowPoint.x + contentSize.width/2 > _theSuperview.viewWidth - kPadding) {
        x = _theSuperview.viewWidth - kPadding - contentSize.width;
    }
    // 左侧边缘
    if (_arrowPoint.x - contentSize.width/2 < kPadding) {
        x = kPadding;
    }
    
    CGPoint arrowPoint = _arrowPoint;
    if (_popoverArrowDirection == CustomPopoverArrowDirectionUp) {
        arrowPoint = CGPointMake(_arrowPoint.x - x, 0);
    }
    if (_popoverArrowDirection == CustomPopoverArrowDirectionDown) {
        arrowPoint = CGPointMake(_arrowPoint.x - x, contentSize.height);
    }
    
    if (_contentBackgroundView) {
        [_contentBackgroundView removeFromSuperview];
    }
    _contentBackgroundView = [[ContentView alloc] initWithArrowPoint:arrowPoint];
    _contentBackgroundView.popoverArrowDirection = self.popoverArrowDirection;
    _contentBackgroundView.cornerRadius = self.cornerRadius;
    _contentBackgroundView.lineColor = _lineColor;
    _contentBackgroundView.contentBackgroudColor = self.contentBackgroundColor;
    _contentBackgroundView.contentView = _contentView;
    _contentBackgroundView.frame = CGRectMake(_arrowPoint.x, _arrowPoint.y, 0, 0);
    [self addSubview:_contentBackgroundView];
    
    CGRect endFrame = CGRectMake(x, y, contentSize.width, contentSize.height);
    
    if (_animated) {
#ifdef kUsingSpringWithDamping
        [UIView animateWithDuration:kAnimationDuration
                              delay:0
             usingSpringWithDamping:0.7
              initialSpringVelocity:0.5
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
            _contentBackgroundView.frame = endFrame;
            
        } completion:^(BOOL finished) {
            
        }];
#else
        [UIView animateWithDuration:kAnimationDuration
                         animations:^{
            _contentBackgroundView.frame = endFrame;
        }];
#endif
    }
    else {
        _contentBackgroundView.frame = endFrame;
    }
        
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[self class]]) {
        return YES;
    }
    return NO;
}

- (void)setContentView:(UIView *)contentView
{
    if (_contentView) {
        [_contentView removeFromSuperview];
    }
    _contentView = contentView;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setupContentView];
    
#ifdef kTest
    _contentBackgroundView.backgroundColor = [UIColor greenColor];
    _contentView.backgroundColor = [UIColor redColor];
#endif
}
@end


@implementation ContentView

- (instancetype)initWithArrowPoint:(CGPoint)arrowPoint
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        self.clipsToBounds = YES;
        
        self.cornerRadius = kCornerRadiusDefault;
        _arrowPoint = arrowPoint;
        _arrowHeight = kArrowHeightDefault;
        _arrowWidth = kArrowWidthDefault;
    }
    return self;
}
#pragma mark setter method
- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = _cornerRadius;
    self.contentView.layer.cornerRadius = _cornerRadius;
}
- (void)setContentView:(UIView *)contentView
{
    _contentView = contentView;
    if (_contentView) {
        [_contentView removeFromSuperview];
    }

    [self addSubview:_contentView];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat y = _arrowHeight;
    if (self.popoverArrowDirection == CustomPopoverArrowDirectionDown) {
        y = 0;
    }
    _contentView.frame = CGRectMake(kShadowOffset, y, self.viewWidth - kShadowOffset * 2, self.viewHeight - _arrowHeight-kShadowOffset);
    _contentView.layer.cornerRadius = _cornerRadius;
    _contentView.clipsToBounds = YES;
}
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGPoint arrowLeftPoint;
    CGPoint arrowRightPoint;
    if (self.popoverArrowDirection == CustomPopoverArrowDirectionUp) {
        _leftUpPoint = CGPointMake(kShadowOffset, _arrowHeight);
        _leftDownPoint = CGPointMake(_leftUpPoint.x, self.viewHeight - kShadowOffset);
        _rightUpPoint = CGPointMake(_leftUpPoint.x + self.viewWidth - kShadowOffset * 2, _leftUpPoint.y);
        _rightDownPoint = CGPointMake(_rightUpPoint.x, self.viewHeight - kShadowOffset);
        
        arrowLeftPoint = CGPointMake(_arrowPoint.x - _arrowWidth/2, _arrowPoint.y + _arrowHeight);
        arrowRightPoint = CGPointMake(arrowLeftPoint.x + _arrowWidth, arrowLeftPoint.y);
    }
    else if (self.popoverArrowDirection == CustomPopoverArrowDirectionDown) {
        _leftUpPoint = CGPointMake(kShadowOffset, self.viewHeight - _arrowHeight);
        _leftDownPoint = CGPointMake(_leftUpPoint.x, kShadowOffset);
        _rightUpPoint = CGPointMake(_leftUpPoint.x + self.viewWidth - kShadowOffset * 2, _leftUpPoint.y);
        _rightDownPoint = CGPointMake(_rightUpPoint.x, kShadowOffset);
        
        arrowLeftPoint = CGPointMake(_arrowPoint.x - _arrowWidth/2, _arrowPoint.y - _arrowHeight);
        arrowRightPoint = CGPointMake(arrowLeftPoint.x + _arrowWidth, arrowLeftPoint.y);
    }
    
    // 设置画线颜色 移动到起始画线点
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
    if (self.lineColor) {
        [self.lineColor getRed:&red green:&green blue:&blue alpha:&alpha];
    }
    CGContextSetRGBStrokeColor(context, red, green, blue, alpha);
    
    // 箭头左侧
    CGFloat cpOffset = _arrowWidth/6;
    CGContextMoveToPoint(context, _arrowPoint.x, _arrowPoint.y);
    CGPoint leftcp1 = CGPointMake(_arrowPoint.x - cpOffset, _arrowPoint.y);
    CGPoint leftcp2 = CGPointMake(_arrowPoint.x - cpOffset, _arrowPoint.y + _arrowHeight);
    if (self.popoverArrowDirection == CustomPopoverArrowDirectionDown) {
        leftcp2 = CGPointMake(_arrowPoint.x - cpOffset, _arrowPoint.y - _arrowHeight);
    }
    CGContextAddCurveToPoint(context, leftcp1.x, leftcp1.y, leftcp2.x, leftcp2.y, arrowLeftPoint.x, arrowLeftPoint.y);
    
    
    // 左上角弧线
    CGPoint leftUpArcStartPoint = CGPointMake(_leftUpPoint.x + _cornerRadius, _leftUpPoint.y);
    CGPoint leftUpArcEndPoint = CGPointMake(_leftUpPoint.x, _leftUpPoint.y + _cornerRadius);
    if (self.popoverArrowDirection == CustomPopoverArrowDirectionDown) {
        leftUpArcEndPoint = CGPointMake(_leftUpPoint.x, _leftUpPoint.y - _cornerRadius);
    }
    CGContextAddLineToPoint(context, leftUpArcStartPoint.x, leftUpArcStartPoint.y);
    CGContextAddArcToPoint(context, _leftUpPoint.x, _leftUpPoint.y, leftUpArcEndPoint.x, leftUpArcEndPoint.y, _cornerRadius);
    
    // 左下角弧线
    CGPoint leftDownArcStartPoint = CGPointMake(_leftDownPoint.x, _leftDownPoint.y - _cornerRadius);
    if (self.popoverArrowDirection == CustomPopoverArrowDirectionDown) {
        leftDownArcStartPoint = CGPointMake(_leftDownPoint.x, _leftDownPoint.y + _cornerRadius);
    }
    CGPoint leftDownArcEndPoint = CGPointMake(_leftDownPoint.x + _cornerRadius, _leftDownPoint.y);
    CGContextAddLineToPoint(context, leftDownArcStartPoint.x, leftDownArcStartPoint.y);
    CGContextAddArcToPoint(context, _leftDownPoint.x, _leftDownPoint.y, leftDownArcEndPoint.x, leftDownArcEndPoint.y, _cornerRadius);
    
    // 右下角弧线
    CGPoint rightDownArcStartPoint = CGPointMake(_rightDownPoint.x - _cornerRadius, _rightDownPoint.y);
    CGPoint rightDownArcEndPoint = CGPointMake(_rightDownPoint.x, _rightDownPoint.y - _cornerRadius);
    if (self.popoverArrowDirection == CustomPopoverArrowDirectionDown) {
        rightDownArcEndPoint = CGPointMake(_rightDownPoint.x, _rightDownPoint.y + _cornerRadius);
    }
    CGContextAddLineToPoint(context, rightDownArcStartPoint.x, rightDownArcStartPoint.y);
    CGContextAddArcToPoint(context, _rightDownPoint.x, _rightDownPoint.y, rightDownArcEndPoint.x, rightDownArcEndPoint.y, _cornerRadius);
    
    // 右上角弧线
    CGPoint rightUpArcStartPoint = CGPointMake(_rightUpPoint.x, _rightUpPoint.y + _cornerRadius);
    if (self.popoverArrowDirection == CustomPopoverArrowDirectionDown) {
        rightUpArcStartPoint = CGPointMake(_rightUpPoint.x, _rightUpPoint.y - _cornerRadius);
    }
    CGPoint rightUpArcEndPoint = CGPointMake(_rightUpPoint.x - _cornerRadius, _rightUpPoint.y);
    CGContextAddLineToPoint(context, rightUpArcStartPoint.x, rightUpArcStartPoint.y);
    CGContextAddArcToPoint(context, _rightUpPoint.x, _rightUpPoint.y, rightUpArcEndPoint.x, rightUpArcEndPoint.y, _cornerRadius);
    
    CGContextAddLineToPoint(context, arrowRightPoint.x, arrowRightPoint.y);
    
    // 右侧箭头
    CGContextMoveToPoint(context, arrowRightPoint.x, arrowRightPoint.y);
    CGPoint rightcp1 = CGPointMake(_arrowPoint.x + cpOffset, _arrowPoint.y + _arrowHeight);
    if (self.popoverArrowDirection == CustomPopoverArrowDirectionDown) {
        rightcp1 = CGPointMake(_arrowPoint.x + cpOffset, _arrowPoint.y - _arrowHeight);
    }
    CGPoint rightcp2 = CGPointMake(_arrowPoint.x + cpOffset, _arrowPoint.y);
    CGContextAddCurveToPoint(context, rightcp1.x, rightcp1.y, rightcp2.x, rightcp2.y, _arrowPoint.x, _arrowPoint.y);
    red = 1.0;
    green = 1.0;
    blue = 1.0;
    alpha = 1.0;
    if (self.contentBackgroudColor) {
        [self.contentBackgroudColor getRed:&red green:&green blue:&blue alpha:&alpha];
    }
    
    CGContextSetShadow(context, CGSizeMake(0, 0), 5);
    CGContextSetRGBFillColor(context, red, green, blue, alpha);
    CGContextFillPath(context);
    
    
    CGContextStrokePath(context);
}
- (void)drawLinearGradientInContext:(CGContextRef)context
{
    // 创建色彩空间对象
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    // 创建起点颜色
    CGColorRef beginColor = CGColorCreate(colorSpaceRef, (CGFloat[]){0.01f, 0.99f, 0.01f, 1.0f});
    // 创建终点颜色
    CGColorRef endColor = CGColorCreate(colorSpaceRef, (CGFloat[]){0.99f, 0.99f, 0.01f, 1.0f});
    // 创建颜色数组
    CFArrayRef colorArray = CFArrayCreate(kCFAllocatorDefault, (const void*[]){beginColor, endColor}, 2, nil);
    // 创建渐变对象
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpaceRef, colorArray, (CGFloat[]){
        0.0f,       // 对应起点颜色位置
        0.1f        // 对应终点颜色位置
    });
    
    // 释放颜色数组
    CFRelease(colorArray);
    // 释放起点和终点颜色
    CGColorRelease(beginColor);
    CGColorRelease(endColor);
    // 释放色彩空间
    CGColorSpaceRelease(colorSpaceRef);
    
    CGContextDrawLinearGradient(context, gradient, _leftUpPoint, _leftDownPoint, 0);
    // 释放渐变对象
    CGGradientRelease(gradient);
}
@end
