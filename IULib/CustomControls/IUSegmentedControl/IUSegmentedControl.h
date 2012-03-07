//
//  IUSegmentedControl.h
//  IULib
//
//  Created by wimo wimo on 12. 2. 29..
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *@class    IUSegmentedControl
 *@brief    각종 커스터마이징을 지원하는 SegmentedControl입니다.
 *@version  1.0
 *@author   Cangel
 */
@interface IUSegmentedControl : UISegmentedControl{
    @private
    NSMutableArray              *_pItems;
    
    UIColor                     *_pOffTintColor;
    UIColor                     *_pOnTintColor;
    UIColor                     *_pOnTextColor;
    UIColor                     *_pOffTextColor;
    UIFont                      *_pOnFont;
    UIFont                      *_pOffFont;
}
@property(nonatomic, retain)    UIColor *offTintColor;   ///<선택되지 않은 Segment색상
@property(nonatomic, retain)    UIColor *onTintColor;    ///<선택 된 Segment색상
@property(nonatomic, retain)    UIColor *onTextColor;    ///<선택 된 Segment Text색상
@property(nonatomic, retain)    UIColor *offTextColor;   ///<선택되지 않은 Segment Text색상
@property(nonatomic, retain)    UIFont  *onFont;         ///<선택 된 Segment Font
@property(nonatomic, retain)    UIFont  *offFont;        ///<선택되지 않은 Segment Font

@end
