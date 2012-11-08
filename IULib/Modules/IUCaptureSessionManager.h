//
//  IUCaptureSessionManager.h
//  IULib
//
//  Created by young-soo park on 12. 9. 5..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef void (^IUCaputureSessionManagerComplateBlock)(UIImage *image, NSError *error);

/**
 *@class        IUCaptureSessionManager
 *@brief        카메라 미리보기 View를 제공하고 촬영가능하게 해줍니다.
 *@version      1.0
 *@author       Cangel
 */
@interface IUCaptureSessionManager : NSObject

@property   (nonatomic, retain)     AVCaptureVideoPreviewLayer      *previewLayer;
@property   (nonatomic, retain)     AVCaptureSession                *captureSession;
@property   (nonatomic, retain)     AVCaptureStillImageOutput       *captureStillImageOutput;

- (void)captureStillImageWithComplate:(IUCaputureSessionManagerComplateBlock)complate;

@end
