//
//  TestListViewController.h
//  IULib
//
//  Created by wimo wimo on 12. 3. 6..
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *@class    TestListViewController
 *@brief    테스트 항목 List 페이지 입니다.
 *@author   Cangel
 */

@interface TestListViewController : UITableViewController{
    @private
    NSMutableArray              *_pSectionArray;
    NSMutableDictionary         *_pItemDic;
}

@end
