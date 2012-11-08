//
//  IUBlockAlertView.h
//  IULib
//
//  Created by young-soo park on 12. 10. 5..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *@brief    AlertView의 버튼 클릭 결과를 넘겨받는 Block문입니다.
 *@param    buttonIndex 클릭된 버튼의 인덱스
 */
typedef void(^IUBlockAlertViewFinishBlock)(NSInteger buttonIndex);

/**
 *@class    IUBlockAlertView
 *@brief    블록문으로 결과를 처리하는 AlertView입니다.
 */
@interface IUBlockAlertView : UIAlertView <UIAlertViewDelegate>

@property   (nonatomic, copy) IUBlockAlertViewFinishBlock finishblock;

- (void)showWithFinishBlock:(IUBlockAlertViewFinishBlock)block;

@end
