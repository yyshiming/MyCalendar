//
//  ScanViewController.m
//  KDBCommon
//
//  Created by YY on 15/7/6.
//  Copyright (c) 2015年 YY. All rights reserved.
//

#import "ScanViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ScanViewController () <AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession *_captureSession;
    AVCaptureDeviceInput *_captureDeviceInput;
    AVCaptureMetadataOutput *_captureMetadataDataOutput;
    AVCaptureVideoPreviewLayer *_videoPreviewLayer;
}
@end

@implementation ScanViewController

- (void)dealloc
{
    _captureSession = nil;
    _captureDeviceInput = nil;
    [_captureMetadataDataOutput setMetadataObjectsDelegate:nil queue:NULL];
    _captureMetadataDataOutput = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willResignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];

    if ([self setupCaptureSession]) {
        [self startCaptureSession];
    }

}
- (BOOL)setupCaptureSession
{
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (videoDevice && videoDevice.connected) {
        // Get the device name
        NSLog(@"Audio Device Name: %@", videoDevice.localizedName);
    } else {
        NSLog(@"AVCaptureDevice defaultDeviceWithMediaType failed or device not connected!");
        return NO;
    }

    // Create the capture session
    _captureSession = [[AVCaptureSession alloc] init];
    if (!_captureSession) {
        NSLog(@"AVCaptureSession allocation failed!");;
        return NO;
    }

    // Create and add a device input for the audio device to the session
    NSError *error = nil;
    _captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
    if (!_captureDeviceInput) {
        NSLog(@"AVCaptureDeviceInput allocation failed! %@", [error localizedDescription]);
        return NO;
    }

    if ([_captureSession canAddInput: _captureDeviceInput]) {
        [_captureSession addInput:_captureDeviceInput];
    } else {
        NSLog(@"Could not addInput to Capture Session!");
        return NO;
    }

    // Create and add a AVCaptureAudioDataOutput object to the session
    _captureMetadataDataOutput = [AVCaptureMetadataOutput new];

    if (!_captureMetadataDataOutput) {
        NSLog(@"Could not create AVCaptureAudioDataOutput!");
        return NO;
    }

    if ([_captureSession canAddOutput:_captureMetadataDataOutput]) {
        [_captureSession addOutput:_captureMetadataDataOutput];
    } else {
        NSLog(@"Could not addOutput to Capture Session!");
        return NO;
    }

    // Create a serial dispatch queue and set it on the AVCaptureAudioDataOutput object
    dispatch_queue_t audioDataOutputQueue = dispatch_queue_create("AudioDataOutputQueue", DISPATCH_QUEUE_SERIAL);
    if (!audioDataOutputQueue){
        NSLog(@"dispatch_queue_create Failed!");
        return NO;
    }

    [_captureMetadataDataOutput setMetadataObjectsDelegate:self queue:audioDataOutputQueue];

    NSMutableArray *metadataObjectTypes = [NSMutableArray arrayWithArray:
                                           @[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code ,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeUPCECode,AVMetadataObjectTypePDF417Code,AVMetadataObjectTypeAztecCode,AVMetadataObjectTypeCode39Code]];
    switch (self.scanType) {
        case ScanTypeDefault:
            [metadataObjectTypes addObject:AVMetadataObjectTypeQRCode];
            break;
        case ScanTypeQRCode:
            metadataObjectTypes = [NSMutableArray arrayWithArray:@[AVMetadataObjectTypeQRCode]];
            break;
        case ScanTypeBarCode:
            break;
        default:
            break;
    }
    [_captureMetadataDataOutput setMetadataObjectTypes:metadataObjectTypes];

    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:self.view.bounds];
    [self.view.layer addSublayer:_videoPreviewLayer];

    return YES;
}
- (BOOL)resetCaptureSession
{
    if (_captureSession) {
        _captureSession = nil;
    }

    // Create the capture session
    _captureSession = [[AVCaptureSession alloc] init];
    if (!_captureSession) {
        NSLog(@"AVCaptureSession allocation failed!");
        return NO;
    }

    if ([_captureSession canAddInput:_captureDeviceInput]) {
        [_captureSession addInput:_captureDeviceInput];
    } else {
        NSLog(@"Could not addInput to Capture Session!");
        return NO;
    }

    if ([_captureSession canAddOutput:_captureMetadataDataOutput]) {
        [_captureSession addOutput:_captureMetadataDataOutput];
    } else {
        NSLog(@"Could not addOutput to Capture Session!");
        return NO;
    }

    return YES;
}
- (void)startCaptureSession
{
    if (!_captureSession.running) {
        [_captureSession startRunning];
        _isReading = YES;
    }
}
- (void)stopCaptureSession
{
    if (_captureSession.running) {
        [_captureSession stopRunning];
        _isReading = NO;
    }
}


- (void)willResignActive
{
    NSLog(@"CaptureSessionController willResignActive");
    [self stopCaptureSession];
}

// we want to start the capture session again automatically on active
- (void)didBecomeActive
{
    NSLog(@"CaptureSessionController didBecomeActive");
    [self startCaptureSession];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects
      fromConnection:(AVCaptureConnection *)connection
{
    if (!self.isReading) return;

    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        NSString *string = metadataObj.stringValue;
        NSLog(@"result:%@",string);
        [self stopCaptureSession];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
