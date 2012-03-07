//
//  TestIURangeController.h
//  IULib
//
//  Created by wimo wimo on 12. 3. 6..
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IURangeSliderControl.h"

/**
 *@class    TestIURangeSliderControl
 *@brief    IURangeSliderControl을 테스트하는 뷰페이지입니다.
 *@author   Cangel
 */

@interface TestIURangeSliderControl : UIViewController

@property (nonatomic, retain)       IBOutlet    UILabel                     *minValueLabel; ///<    선택된 최소값을 출력하는 라벨
@property (nonatomic, retain)       IBOutlet    UILabel                     *maxValueLabel; ///<    선택된 최대값을 출력하는 라벨
@property (nonatomic, retain)       IBOutlet    IURangeSliderControl        *testIURangeSlider; ///<    테스트용 IURangeSliderControl

-(void)sliderValueChange; ///<    테스트용 IURangeSliderControl ValueChangeEvent 함수

@end
