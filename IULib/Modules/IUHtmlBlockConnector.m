//
//  IUHtmlBlockConnector.m
//  IULib
//
//  Created by young-soo park on 12. 9. 5..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "IUHtmlBlockConnector.h"


@implementation IUHtmlBlockConnector

/**
 *@brief    GCD와 블록구문을 이용한 Html통신입니다.
 *@param    request         요청할 Request입니다.
 *@param    complateBlock   완료시 실행 될 Block구문.
 */

+ (void)conntectRequest:(NSURLRequest *)request complate:(IUBlockConnectorComplateBlock)complateBlock
{
    dispatch_queue_t queue = dispatch_queue_create("que", NULL);
    
    dispatch_async(queue, ^{
        NSError *error = nil;
        NSURLResponse *response = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        
        complateBlock(data, response, error);
    });
    
    dispatch_release(queue);
    
}

@end
