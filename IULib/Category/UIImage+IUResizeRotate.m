//
//  UIImage+IUResizeRotate.m
//  IULib
//
//  Created by young-soo park on 12. 9. 5..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "UIImage+IUResizeRotate.h"

@implementation UIImage(IUResizeRotate)

/**
 *@brief    이미지를 리사이징 합니다.
 *@param    image           원본 이미지
 *@param    resizeWidth     리사이징 할 넓이
 *@param    resizeHeight    리사이징 할 높이
 *@return   리사이징 된 이미지
 */
+ (UIImage *)Image:(UIImage *)image ResizeWithWidth:(float)resizeWidth height:(float)resizeHeight
{
    UIGraphicsBeginImageContext(CGSizeMake(resizeWidth, resizeHeight));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, resizeHeight);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGRectMake(0.0, 0.0, resizeWidth, resizeHeight), [image CGImage]);
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

/**
 *@brief    이미지를 회전 합니다.
 *@param    image           원본 이미지
 *@param    angleDegrees    회전할 각도
 *@return   회전 된 이미지
 */
+ (UIImage *)Image:(UIImage *)image RotateWithAngle:(float) angleDegrees
{
    UIView* rotatedViewBox = [[UIView alloc] initWithFrame: CGRectMake(0, 0, image.size.width, image.size.height)];
    float angleRadians = angleDegrees * ((float)M_PI / 180.0f);
    CGAffineTransform t = CGAffineTransformMakeRotation(angleRadians);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    [rotatedViewBox release];
    
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    CGContextRotateCTM(bitmap, angleRadians);
    
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-image.size.width / 2, -image.size.height / 2, image.size.width, image.size.height), [image CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
