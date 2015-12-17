//
//  BaseViewController.m
//  KDBCommon
//
//  Created by YY on 15/7/1.
//  Copyright (c) 2015年 YY. All rights reserved.
//

#import "YYBaseViewController.h"

@interface YYBaseViewController () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end
@implementation YYBaseViewController

#pragma mark - 选择照片来源
- (void)showImagePickerActionSheet
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册中选择", nil];
    [actionSheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0: // 拍照
        {
            [self choosePhotoWithSourceType:UIImagePickerControllerSourceTypeCamera];
        }
            break;
        case 1: // 从相册中选择
        {
            [self choosePhotoWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
            break;
        default:
            break;
    }
}

- (void)choosePhotoWithSourceType:(UIImagePickerControllerSourceType)sourceType
{
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        //设置拍照后的图片可被编辑
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = sourceType;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else {
        NSString *message = nil;
        if (sourceType == UIImagePickerControllerSourceTypeCamera) {
            message = @"无法打开照相机";
        }
        else if (sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
            message = @"无法打开相册";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    UIImage *editImage = [info objectForKey:UIImagePickerControllerEditedImage];
    //    UIImage *postImage = [self scaleToSize:image size:CGSizeMake(200.0, 200.0)];
    //    BOOL flag = [Utility uploadImage:postImage];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - lift circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    MYLog(@"viewDidLoad");
    [self.view setBackgroundColor:[UIColor whiteColor]];
    if (kDeviceSystemVersion > 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    MYLog(@"%@",NSStringFromClass([self class]));
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    MYLog(@"viewWillAppear");
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    MYLog(@"viewWillLayoutSubviews");
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    MYLog(@"viewDidLayoutSubviews");
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    MYLog(@"viewDidAppear");
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    MYLog(@"viewWillDisappear");
}
#pragma mark - getter method

#pragma mark - setter method

@end
