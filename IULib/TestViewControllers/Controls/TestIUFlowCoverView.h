//
//  TestIUFlowCoverView.h
//  IULib
//
//  Created by wimo wimo on 12. 3. 8..
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IUFlowCoverView.h"

/**
 *@class    TestIUFlowCoverView
 *@brief    IUFlowCoverView을 테스트하는 뷰페이지입니다.
 *@author   Cangel
 */
@interface TestIUFlowCoverView : UIViewController<IUFlowCoverViewDataSource, IUFlowCoverViewDelegate>

@property(nonatomic, retain)    IBOutlet    IUFlowCoverView     *iuFlowCoverView; ///<  테스트용 IUFlowCoverView

- (IBAction)loopSwitch:(id)sender;      ///<    루프 스위치 이벤트
- (IBAction)shadowSwitch:(id)sender;    ///<    섀도우 스위치 이벤트

@end
