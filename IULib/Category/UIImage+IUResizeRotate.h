//
//  UIImage+IUResizeRotate.h
//  IULib
//
//  Created by young-soo park on 12. 9. 5..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *@class        UIImage(IUResizeRotate)
 *@brief        UIImage에 리사이즈, 회전 기능을 넣어줍니다.
 *@version      1.0
 *@author       Cangel
 */
@interface UIImage(IUResizeRotate)

+ (UIImage *)Image:(UIImage *)image ResizeWithWidth:(float)resizeWidth height:(float)resizeHeight;
+ (UIImage *)Image:(UIImage *)image RotateWithAngle:(float) angleDegrees;

@end
