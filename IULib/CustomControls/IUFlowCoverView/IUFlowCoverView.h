//
//  IUCoverFlowView.h
//  IULib
//
//  Created by wimo wimo on 12. 3. 8..
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGLDrawable.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

@protocol IUFlowCoverViewDelegate;
@protocol IUFlowCoverViewDataSource;

/**
 *@class    IUFlowCoverCache
 *@brief        FlowCover 빠른 출력을 위한 캐쉬클래스입니다.
 *@version      1.0
 *@author       Cangel
 */
@interface IUFlowCoverCache : NSObject {
@private
    int                     _nCapacity;
    NSMutableDictionary     *_pDictionary;
    NSMutableArray          *_pAge;
}

- (id)initWithCapacity:(NSInteger)capacity;

- (id)objectForKey:(id)akey;
- (void)setObject:(id)anObject forKey:(id)aKey;
- (void)clear;
@end

/*@brief    IUFlowCoverView의 Image보여주는 형식입니다.*/
typedef enum IUFlowCoverViewImageMode{
    IUFlowCoverViewImageModeScaleFitCenter,     ///<    화면에 사이즈 맞춘 다음 가운데 정렬
    IUFlowCoverViewImageModeFill,               ///<    비율 상관없이 화면에 맞추기
    IUFlowCoverViewImageModeScaleFitCenterDown, ///<    화면에 사이즈 맞춘 다음 가운데 하단 정렬
    IUFlowCoverViewImageModeTopLeftCrop,        ///<    이미지를 좌측 상단에 맞춘뒤 자르기
    IUFlowCoverViewImageModeCenterCrop          ///<    이미지를 가운데에 맞춘 다음 자르기
}IUFlowCoverViewImageMode;

/**
 *@class    IUFlowCoverView
 *@brief    앨범아트와 같은 형식의 갤러리뷰입니다.
 *@warning  OpenGLES.framework, QuartzCore.framework가 포함되어야 됩니다.
 *@version  1.0
 *@author   Cangel
 */
@interface IUFlowCoverView : UIView{
    @private
    double                          _dOffSet;
    
    NSTimer                         *_pTimer;
    
    double                          _dStartTime;
    double                          _dStartOff;
    double                          _dStartPos;
    double                          _dStartSpeed;
    
    double                          _dRunDelta;
    
    BOOL                            _bTouchFlag;
    
    CGPoint                         _startTouchPoint;
    
    double                          _dLastPos;
    
    id<IUFlowCoverViewDelegate>     _pDelegate;
    id<IUFlowCoverViewDataSource>   _pDataSource;
    
    IUFlowCoverCache                *_pCache;
    
    GLint                           _nBackingWidth;
    GLint                           _nBackingHeight;
    EAGLContext                     *_pContext;
    GLuint                          _nViewRenderBuffer;
    GLuint                          _nViewFrameBuffer;
    GLuint                          _nDepthRenderBuffer;
    
    BOOL                            _bEnableLoop;
    BOOL                            _bEnableShadow;
    
    UIColor                         *_pSlotColor;
    
    IUFlowCoverViewImageMode        _eImageMode;
}

@property (nonatomic, assign)       IBOutlet    id<IUFlowCoverViewDelegate>     delegate;       
///<    선택이벤트를 넘겨줄 delegate
@property (nonatomic, assign)       IBOutlet    id<IUFlowCoverViewDataSource>   dataSource;     
///<    View에 나올 데이터들을 넘겨줄  dataSource
@property (nonatomic)               BOOL                                        enableLoop;     
///<    이미지들을 루프해서 보여줄 것인지 체크. default : NO
@property (nonatomic)               BOOL                                        enableShadow;
///<    하단에 반사이미지를 보여줄 것인지 체크. default : YES

@property (nonatomic, retain)       UIColor                                     *slotColor;
///<    이미지가 출력되는 슬롯의 배경색. default : ClearColor

@property (nonatomic)               IUFlowCoverViewImageMode                    imageMode;
///<    이미지가 출력되는 방식을 지정합니다. default : IUFlowCoverViewImageModeScaleFitCenter

- (void)reload;

@end

/**
 *@brief    IUFlowCoverView의 선택 이벤트를 전달받는 delegate입니다.
 *@author   Cangel
 */
@protocol IUFlowCoverViewDelegate <NSObject>

@required
- (void)didSelectedIUFlowCoverView:(IUFlowCoverView *)view atIndex:(NSInteger)index;    ///<    선택된 이미지의 인덱스를 넘겨줍니다.

@end

/**
 *@brief    IUFlowCoverView에 필요한 데이터를 넘겨주는 프로토콜입니다.
 *@author   Cangel
 */
@protocol IUFlowCoverViewDataSource <NSObject>

@required
- (int)imageCountOfIUFlowCoverView:(IUFlowCoverView *)view;                             ///<    총 이미지의 갯수를 넘겨받습니다.
- (UIImage *)getImageForIUFlowCoverView:(IUFlowCoverView *)view index:(NSInteger)index; ///<    해당 인덱스의 이미지를 넘겨받습니다.

@end
