//
//  IUHtmlBlockConnector.h
//  IULib
//
//  Created by young-soo park on 12. 9. 5..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

/**
 *@class        IUHtmlBlockConnector
 *@brief        Block구문과 GCD를 이용한 HtmlConnetor입니다.
 *@version      1.0
 *@author       Cangel
 */
#import <UIKit/UIKit.h>

typedef void(^IUBlockConnectorComplateBlock)(NSData *data, NSURLResponse *response, NSError *error);

@interface IUHtmlBlockConnector : NSObject

+ (void)conntectRequest:(NSURLRequest *)request complate:(IUBlockConnectorComplateBlock)complateBlock;

@end
