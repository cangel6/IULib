//
//  IUCaptureSessionManager.m
//  IULib
//
//  Created by young-soo park on 12. 9. 5..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "IUCaptureSessionManager.h"
#import <ImageIO/ImageIO.h>

@interface IUCaptureSessionManager(private)

- (void)setVideoPreviewLayer;
- (void)setVideoInput;
- (void)setStillImageOutput;

@end

@implementation IUCaptureSessionManager

@synthesize previewLayer;
@synthesize captureSession;
@synthesize captureStillImageOutput;

- (id)init{
    self = [super init];
    if (self) {
        [self setCaptureSession:[[[AVCaptureSession alloc]init]autorelease]];
        [self setVideoInput];
        [self setVideoPreviewLayer];
        [self setStillImageOutput];
        
        /**
         오토포커스 완료 이벤트 리스너 설정
         **/
        AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        int flags = NSKeyValueObservingOptionNew; 
        [captureDevice addObserver:self forKeyPath:@"adjustingFocus" options:flags context:nil];
    }
    return self;
}

- (void)dealloc
{
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [captureDevice removeObserver:self forKeyPath:@"adjustingFocus"];
    
    [self.captureSession stopRunning];
    self.captureSession = nil;
    self.captureStillImageOutput = nil;
    self.previewLayer = nil;
    
    [super dealloc];
}

- (void)setVideoPreviewLayer
{
    [self setPreviewLayer:nil];
    [self setPreviewLayer:[[[AVCaptureVideoPreviewLayer alloc]initWithSession:self.captureSession]autorelease]];
    [[self previewLayer] setVideoGravity:AVLayerVideoGravityResizeAspectFill];
}

- (void)setVideoInput
{
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([captureDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
        [captureDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
    }
    
    if (captureDevice) {
        NSError *error;
        AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
        if (!error) {
            if ([self.captureSession canAddInput:deviceInput]) {
                [self.captureSession addInput:deviceInput];
            }else {
                NSLog(@"Couldn't add video input");
            }
        }else {
            NSLog(@"Couldn't create video input");
        }
    }else {
        NSLog(@"Couldn't create video capture device");
    }
}

- (void)setStillImageOutput
{
    captureStillImageOutput = nil;
    [self setCaptureStillImageOutput:[[[AVCaptureStillImageOutput alloc]init]autorelease]];
    NSDictionary *outputSetting = [[NSDictionary alloc]initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    [self.captureStillImageOutput setOutputSettings:outputSetting];
    
    [outputSetting release];
    [self.captureSession addOutput:self.captureStillImageOutput];
}

/**
 *@brief    카메라로 찍고 있는 장면을 촬영합니다.
 *@param    complate   완료되었을 시 실행될 구문입니다.
 */
- (void)captureStillImageWithComplate:(IUCaputureSessionManagerComplateBlock)complate
{
    AVCaptureConnection *videoConnecton = nil;
    for (AVCaptureConnection *connection in [self.captureStillImageOutput connections]) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([port.mediaType isEqualToString:AVMediaTypeVideo]) {
                videoConnecton = connection;
                break;
            }
        }
        if (videoConnecton) break;
    }
    
    if (videoConnecton) {
        [self.captureStillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnecton 
                                                                  completionHandler:^(CMSampleBufferRef imageSampleBuffer, NSError *error){
                                                                      
                                                                      NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
                                                                      UIImage *captureImage = [UIImage imageWithData:imageData];
                                                                      complate(captureImage, error);
                                                                  }];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if( [keyPath isEqualToString:@"adjustingFocus"] ){
        BOOL adjustingFocus = [ [change objectForKey:NSKeyValueChangeNewKey] isEqualToNumber:[NSNumber numberWithInt:1] ];
        if (!adjustingFocus) {
            NSLog(@"focus");
        }
    }
}

@end
