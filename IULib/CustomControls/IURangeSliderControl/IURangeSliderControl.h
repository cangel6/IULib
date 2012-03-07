//
//  IURangeSliderControl.h
//  IULib
//
//  Created by wimo wimo on 12. 3. 2..
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *@class    IURangeSliderControl
 *@brief    범위조절에 사용되는 dual slider 입니다.
 *@version  1.0
 *@author   Cangel
 */

@interface IURangeSliderControl : UIControl{
    @private
    float                   _fMinValue;
    float                   _fMaxValue;
    float                   _fMinRange;
    float                   _fSelMinValue;
    float                   _fSelMaxValue;
    
    BOOL                    _bMaxThumbOn;
    BOOL                    _bMinThumbOn;
    float                   _fPadding;
    
    UIImageView             *_pMinThumb;
    UIImageView             *_pMaxThumb;
    UIImageView             *_pTrack;
    UIImageView             *_pTrackBackGround;
}
@property(nonatomic)            float   minimumValue;               ///<    최소값
@property(nonatomic)            float   maximumValue;               ///<    최대값
@property(nonatomic)            float   minimumRange;               ///<    최소범위
@property(nonatomic)            float   selectedMinimumValue;       ///<    선택된 최소값
@property(nonatomic)            float   selectedMaximumValue;       ///<    선택된 최대값

@property(nonatomic, retain)    UIImage *maximumTrackImage;         ///<    선택영역 트랙 이미지
@property(nonatomic, retain)    UIImage *minimumTrackImage;         ///<    비선택 영역 트랙 이미지
@property(nonatomic, retain)    UIImage *thumbImage;                ///<    조절 버튼 이미지

- (void)initializeControl;

- (void)setThumbImage:(UIImage *)image forState:(UIControlState)state;
- (void)setMinimumTrackImage:(UIImage *)image forState:(UIControlState)state;
- (void)setMaximumTrackImage:(UIImage *)image forState:(UIControlState)state;

@end
