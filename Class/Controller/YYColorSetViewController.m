//
//  YYColorSetVC.m
//  MyCalendar
//
//  Created by Zsm on 15/12/22.
//  Copyright © 2015年 zhang. All rights reserved.
//

#import "YYColorSetViewController.h"

@interface YYColorSetViewController ()
{
    UISlider *_redSlider;
    UISlider *_greenSlider;
    UISlider *_blueSlider;
    
    UILabel *_redLabel;
    UILabel *_greenLabel;
    UILabel *_blueLabel;
    
    UIView   *_indicaterView;
    UIColor  *_newColor;
}
@end

@implementation YYColorSetViewController
- (void)valueChanged:(UISlider *)slider
{
    _newColor = [UIColor colorWithRed:_redSlider.value
                                green:_greenSlider.value
                                 blue:_blueSlider.value
                                alpha:1];
    _indicaterView.backgroundColor = _newColor;
    
    _redLabel.text = [NSString stringWithFormat:@"%.0f", _redSlider.value*255];
    _greenLabel.text = [NSString stringWithFormat:@"%.0f", _greenSlider.value*255];
    _blueLabel.text = [NSString stringWithFormat:@"%.0f", _blueSlider.value*255];
    
    
    [self.navigationController.navigationBar setBarTintColor:_newColor];
    
    [self reloadWithRed:_redSlider.value
                  green:_greenSlider.value
                   blue:_blueSlider.value];
}
- (void)finished
{
    [YYConfigure setColor:_newColor forKey:kDefaultAppColorKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:kAppColorDidChangedNotification object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    UIColor *defaultColor = [YYConfigure colorForKey:kDefaultAppColorKey];
    [self.navigationController.navigationBar setBarTintColor:defaultColor];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finished)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
    UIColor *defaultColor = [YYConfigure colorForKey:kDefaultAppColorKey];
    [defaultColor getRed:&red green:&green blue:&blue alpha:&alpha];
    
    _indicaterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    _indicaterView.centerX = self.view.viewWidth/2;
    _indicaterView.originY = 20;
    _indicaterView.layer.cornerRadius = 25;
    _indicaterView.clipsToBounds = YES;
    _indicaterView.backgroundColor = defaultColor;
    [self.scrollView addSubview:_indicaterView];
    
    CGFloat leftSpace = 20;
    CGFloat height = 50;
    CGFloat labelWidth = 40;
    _redSlider = [[UISlider alloc] initWithFrame:CGRectMake(leftSpace, _indicaterView.maxY+20, self.view.viewWidth - leftSpace*2 - labelWidth, height)];
    [_redSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.scrollView addSubview:_redSlider];
    
    _greenSlider = [[UISlider alloc] initWithFrame:CGRectMake(leftSpace, _redSlider.maxY, _redSlider.viewWidth, height)];
    [_greenSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.scrollView addSubview:_greenSlider];
    
    _blueSlider = [[UISlider alloc] initWithFrame:CGRectMake(leftSpace, _greenSlider.maxY, _redSlider.viewWidth, height)];
    [_blueSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.scrollView addSubview:_blueSlider];

    
    _redSlider.value = red;
    _greenSlider.value = green;
    _blueSlider.value = blue;
    
    
    _redLabel = [[UILabel alloc] initWithFrame:CGRectMake(_redSlider.maxX, _redSlider.originY, labelWidth, _redSlider.viewHeight)];
    _redLabel.textAlignment = NSTextAlignmentCenter;
    [self.scrollView addSubview:_redLabel];
    
    _greenLabel = [[UILabel alloc] initWithFrame:CGRectMake(_greenSlider.maxX, _greenSlider.originY, labelWidth, _redSlider.viewHeight)];
    _greenLabel.textAlignment = NSTextAlignmentCenter;
    [self.scrollView addSubview:_greenLabel];
    
    _blueLabel = [[UILabel alloc] initWithFrame:CGRectMake(_blueSlider.maxX, _blueSlider.originY, labelWidth, _redSlider.viewHeight)];
    _blueLabel.textAlignment = NSTextAlignmentCenter;
    [self.scrollView addSubview:_blueLabel];
    
    _redLabel.text = [NSString stringWithFormat:@"%.0f", red*255];
    _greenLabel.text = [NSString stringWithFormat:@"%.0f", green*255];
    _blueLabel.text = [NSString stringWithFormat:@"%.0f", blue*255];
    
    [self reloadWithRed:red green:green blue:blue];
}

- (void)reloadWithRed:(CGFloat)red
                green:(CGFloat)green
                 blue:(CGFloat)blue
{
    UIColor *redColor = [UIColor colorWithRed:red green:0 blue:0 alpha:1];
    UIColor *greenColor = [UIColor colorWithRed:0 green:green blue:0 alpha:1];
    UIColor *blueColor = [UIColor colorWithRed:0 green:0 blue:blue alpha:1];
    
    _redSlider.minimumTrackTintColor = redColor;
    _greenSlider.minimumTrackTintColor = greenColor;
    _blueSlider.minimumTrackTintColor = blueColor;
    
    _redLabel.textColor = redColor;
    _greenLabel.textColor = greenColor;
    _blueLabel.textColor = blueColor;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
