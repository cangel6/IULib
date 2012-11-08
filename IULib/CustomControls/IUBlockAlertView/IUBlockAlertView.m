//
//  IUBlockAlertView.m
//  IULib
//
//  Created by young-soo park on 12. 10. 5..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "IUBlockAlertView.h"

@implementation IUBlockAlertView

@synthesize finishblock;

/**
 *@brief    AlertView를 보여주고 버튼 클릭시 블록문을 처리해줍니다.
 *@param    block   버튼 클릭시 처리되는 블록문입니다.
 */
- (void)showWithFinishBlock:(IUBlockAlertViewFinishBlock)block
{
    self.delegate = self;
    self.finishblock = block;
    
    [super show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.finishblock(buttonIndex);
}

@end
