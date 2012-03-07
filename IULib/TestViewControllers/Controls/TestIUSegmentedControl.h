//
//  TestIUSegmentedControl.h
//  IULib
//
//  Created by wimo wimo on 12. 3. 7..
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IUSegmentedControl.h"

/**
 *@class    TestIUSegmentedControl
 *@brief    IUSegmentedControl을 테스트하는 뷰페이지입니다.
 *@author   Cangel
 */
@interface TestIUSegmentedControl : UIViewController

@property (nonatomic, retain)   IBOutlet    IUSegmentedControl  *segCon1; ///<  PlainType 테스트용
@property (nonatomic, retain)   IBOutlet    IUSegmentedControl  *segCon2; ///<  BorderedType 테스트용
@property (nonatomic, retain)   IBOutlet    IUSegmentedControl  *segCon3; ///<  BarType 테스트용
@property (nonatomic, retain)   IBOutlet    IUSegmentedControl  *segCon4; ///<  BezeledType 테스트용

@end
