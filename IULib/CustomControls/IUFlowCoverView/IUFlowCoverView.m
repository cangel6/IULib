//
//  IUCoverFlowView.m
//  IULib
//
//  Created by wimo wimo on 12. 3. 8..
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IUFlowCoverView.h"
#import <QuartzCore/QuartzCore.h>

#define kTextureSize        256     ///<    화면에 그려질 각 텍스쳐의 사이즈
#define kMaxTiles           48      ///<    캐쉬에 저장할 최대 갯수
#define kVisTiles           6       ///<    화면에 그려질 좌우 타일의 갯수

#define kSpreadImage        0.1     ///<    좌/우 타일의 간격
#define kFlankSpread        0.4     ///<    중앙의 타일과 좌/우 타일의 간격
#define kFriction           10.0    ///<    이동 속도의 감속정도
#define kMaxSpeed           10.0    ///<    최대 이동 속도

const GLfloat   GVertices[] = {
    -1.0f, -1.0f, 0.0f, //좌상단
     1.0f, -1.0f, 0.0f, //우상단
    -1.0f,  1.0f, 0.0f, //좌하단
     1.0f,  1.0f, 0.0f  //우하단
};  ///< 텍스쳐가 그려지기 위한 사각형

const GLshort   GTextures[] = {
    0, 0,
    1, 0,
    0, 1,
    1, 1
}; ///< 사각형에 텍스쳐 매핑시키기 위한 텍스쳐좌표

#pragma mark - IUFlowCoverChache

@implementation IUFlowCoverCache

/**
 *@brief    IUFlowCoverCache 생성자
 */
- (id)initWithCapacity:(NSInteger)capacity{
    self = [super init];
    if (self) {
        _nCapacity      = capacity;
        _pDictionary    = [[NSMutableDictionary alloc]initWithCapacity:capacity];
        _pAge           = [[NSMutableArray alloc]initWithCapacity:capacity];
    }
    return self;
}

- (void)dealloc
{
    for (id object in _pDictionary) {
        [object release];
    }
    
    for (id object in _pAge) {
        [object release];
    }
    
    [_pDictionary   removeAllObjects];
    [_pAge          removeAllObjects];
    [_pDictionary   release];
    [_pAge          release];
    
    [super dealloc];
}

/**
 *@brief    키에 맞는 오브젝트를 출력합니다.
 *@param    aKey    찾고 싶은 오브젝트의 키
 *@return   키에 해당되는 오브젝트
 */
- (id)objectForKey:(id)akey{
    NSUInteger index = [_pAge indexOfObject:akey];
    if (index == NSNotFound) return nil;
    if (index != 0) {
        [_pAge removeObjectAtIndex:index];
        [_pAge insertObject:akey atIndex:0];
    }
    
    return [_pDictionary objectForKey:akey];
}

/**
 *@brief    오브젝트와 키를 셋팅합니다.
 *@param    anObject    저장할 오브젝트
 *@param    aKey        저장할 오브젝트의 키
 */
- (void)setObject:(id)anObject forKey:(id)aKey{
    NSUInteger index = [_pAge indexOfObject:aKey];
    if (index != 0) {
        if (index != NSNotFound) {
            [_pAge removeObjectAtIndex:index];
        }
        [_pAge insertObject:aKey atIndex:0];
        
        if ([_pAge count] > _nCapacity) {
            id delKey = [_pAge lastObject];
            [_pDictionary removeObjectForKey:delKey];
            [_pAge removeAllObjects];
        }
    }
    
    [_pDictionary setObject:anObject forKey:aKey];
}

/**
 *@brief    캐쉬를 클리어 합니다.
 */
- (void)clear{
    for (id object in _pDictionary) {
        [object release];
    }
    
    for (id object in _pAge) {
        [object release];
    }
    
    [_pDictionary   removeAllObjects];
    [_pAge          removeAllObjects];
}

@end

#pragma mark - IUFlowCoverRecord

/**
 *@class    IUFlowCoverRecord
 *@brief    FlowCover 의 이미지가 텍스쳐로 저장되는 클래스입니다.
 *@version  1.0
 *@author   Cangel
 */
@interface IUFlowCoverRecord : NSObject {
@private
    GLuint          _nTexture;
}
@property   GLuint      texture;
- (id)initWithTexture:(GLuint)texture;
@end

@implementation IUFlowCoverRecord

@synthesize texture = _nTexture;

/**
 *@brief    IUFlowCoverRecord의 생성자
 */
- (id)initWithTexture:(GLuint)texture{
    self = [super init];
    if (self) {
        _nTexture = texture;
    }
    return self;
}

- (void)dealloc{
    if (_nTexture) {
        glDeleteTextures(1, &_nTexture);
    }
    [super dealloc];
}

@end

#pragma mark - IUFlowCoverView(PrivateMethods)
/**
 *@category IUFlowCoverView(PrivateMethods)
 *@brief    IUFlowCoverView의 PrivateMethods
 *@author   Cangel
 */
@interface IUFlowCoverView (PrivateMethods)

- (BOOL)createFrameBuffer;                              ///<    createFrameBuffer
- (void)destoryFrameBuffer;                             ///<    destroyFrameBuffer

- (id)internalInit;                                     ///<    초기화 함수

- (int)countOfTiles;                                    ///<    DataSource로부터 총 이미지 갯수를 받아옴
- (UIImage *)getImage:(int)index;                       ///<    해당 인덱스의 이미지를 받아옴

- (void)selectAtIndex:(int)index;                       ///<    해당 인덱스의 이미지가 선택됨

- (GLuint)imageToTexture:(UIImage *)image;              ///<    이미지를 텍스쳐로 변환시킴
- (IUFlowCoverRecord *)getTileAtIndex:(int)index;       ///<    해당 인덱스의 텍스쳐가 저장된 클래스를 불러옴

- (void)drawTile:(int)index atOffset:(double)offset;    ///<    해당 타일을 그려줌
- (void)draw;                                           ///<    전체 화면을 그려줌

- (void)updateAnimationAtTime:(double)elapsed;          ///<    애니메이션 도중 처리
- (void)endAnimation;                                   ///<    애니메이션 완료 처리
- (void)driveAnimation;                                 ///<    애니메이션 동작 처리
- (void)startAnimation:(double)speed;                   ///<    애니메이션 시작 처리

@end
 
#pragma mark - IUFlowCoverView

@implementation IUFlowCoverView

@synthesize delegate = _pDelegate;
@synthesize dataSource = _pDataSource;

#pragma mark - OpenGL ES Support Methods

+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

/**
 *@brief    프레임 버퍼를 생성해줍니다.
 *@return   YES : 생성 성공     NO : 생성 실패
 */
- (BOOL)createFrameBuffer
{
    glGenFramebuffersOES(1, &_nViewFrameBuffer);
    glGenRenderbuffersOES(1, &_nViewRenderBuffer);
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, _nViewFrameBuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, _nViewRenderBuffer);
    
    [_pContext renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(id<EAGLDrawable>)self.layer];
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, _nViewRenderBuffer);
    
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &_nBackingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &_nBackingHeight);
    
    if (glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
        NSLog(@"failed to make complate framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }
    return YES;
}

/**
 *@brief    프레임 버퍼를 삭제합니다.
 */
- (void)destoryFrameBuffer
{
    glDeleteFramebuffersOES(1, &_nViewFrameBuffer);
    _nViewFrameBuffer = 0;
    glDeleteRenderbuffersOES(1, &_nViewRenderBuffer);
    _nViewRenderBuffer = 0;
    
    if (_nDepthRenderBuffer) {
        glDeleteRenderbuffersOES(1, &_nDepthRenderBuffer);
        _nDepthRenderBuffer = 0;
    }
}

- (void)layoutSubviews
{
    [EAGLContext setCurrentContext:_pContext];
    [self destoryFrameBuffer];
    [self createFrameBuffer];
    [self draw];
}

#pragma mark - view lifeCycle Methods

/**
 *@brief    현재 뷰에 기본적인 셋팅을 하여 되돌려줍니다.
 *@return   셋팅된 뷰
 */
- (id)internalInit{
    CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
    eaglLayer.opaque = YES;
    
    _pContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
    if (!_pContext || ![EAGLContext setCurrentContext:_pContext] || ![self createFrameBuffer]) {
        [self release];
        return nil;
    }
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    _pCache = [[IUFlowCoverCache alloc]initWithCapacity:kMaxTiles];
    
    _dOffSet = 0;
    _bEnableLoop = NO;
    _bEnableShadow = YES;
    
    _pSlotColor = [UIColor clearColor];
    _eImageMode = IUFlowCoverViewImageModeScaleFitCenter;
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [self internalInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self = [self internalInit];
    }
    return self;
}

- (void)dealloc
{
    [_pCache release];
    
    [EAGLContext setCurrentContext:_pContext];
    
    [self destoryFrameBuffer];
    
    [EAGLContext setCurrentContext:nil];
    
    [_pContext release];
    _pContext = nil;
    
    [_pSlotColor release];
    [super dealloc];
}

#pragma mark - Datasource Call Methods

/**
 *@brief    총 이미지의 갯수를 리턴합니다.
 *@return   이미지의 갯수
 */
- (int)countOfTiles{
    if (_pDataSource) {
        return [_pDataSource imageCountOfIUFlowCoverView:self];
    }else{
        return 0;
    }
}

/**
 *@brief    인덱스에 맞는 이미지를 리턴합니다.
 *@param    index   불러오고 싶은 이미지의 인덱스
 *@return   인덱스에 해당되는 이미지
 */
- (UIImage *)getImage:(int)index{
    if (_pDataSource) {
        return [_pDataSource getImageForIUFlowCoverView:self index:index];
    }else{
        return nil;
    }
}

#pragma mark - Delegate Call Methods

/**
 *@brief    해당 인덱스가 선택되었음을 delegate에 넘겨줍니다.
 *@param    선택된 인덱스
 */
- (void)selectAtIndex:(int)index{
    if (_pDelegate) {
        [_pDelegate didSelectedIUFlowCoverView:self atIndex:index];
    }
}

#pragma mark - Tile Management Methods

static void *GData = NULL;

/**
 *@brief    이미지를 텍스쳐 데이터로 변환합니다.
 *@param    image   변환할 이미지
 */
- (GLuint)imageToTexture:(UIImage *)image{
    if (GData == NULL) GData = malloc(4 * kTextureSize * kTextureSize);

    CGColorSpaceRef cref = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(GData, kTextureSize, kTextureSize, 8, kTextureSize*4, cref, kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(cref);
    UIGraphicsPushContext(context);
    
    [_pSlotColor setFill];
    CGRect rect = CGRectMake(0, 0, kTextureSize, kTextureSize);
    UIRectFill(rect);
    
    CGSize size = image.size;
    
    switch (_eImageMode) {
        case IUFlowCoverViewImageModeScaleFitCenter:
            if (size.width > size.height) {
                size.height = kTextureSize * (size.height / size.width);
                size.width = kTextureSize;
            } else{
                size.width = kTextureSize * (size.width / size.height);
                size.height = kTextureSize;
            }
            
            rect.origin.x = (kTextureSize - size.width)/2;
            rect.origin.y = (kTextureSize - size.height)/2;
            rect.size = size;
            break;
        case IUFlowCoverViewImageModeScaleFitCenterDown:
            if (size.width > size.height) {
                size.height = kTextureSize * (size.height / size.width);
                size.width = kTextureSize;
            } else{
                size.width = kTextureSize * (size.width / size.height);
                size.height = kTextureSize;
            }
            
            rect.origin.x = (kTextureSize - size.width)/2;
            rect.origin.y = (kTextureSize - size.height);
            rect.size = size;
            break;
        case IUFlowCoverViewImageModeFill:
            size.height = kTextureSize;
            size.width = kTextureSize;
            
            rect.size = size;
            break;
        case IUFlowCoverViewImageModeCenterCrop:
            rect.origin.x = (kTextureSize - size.width)/2;
            rect.origin.y = (kTextureSize - size.height)/2;
            rect.size = size;
            break;
        case IUFlowCoverViewImageModeTopLeftCrop:
            rect.size = size;
            break;
    }
    
    
    [image drawInRect:rect];
    
    UIGraphicsPopContext();
    CGContextRelease(context);
    
    GLuint texture = 0;
    glGenTextures(1, &texture);
    [EAGLContext setCurrentContext:_pContext];
    glBindTexture(GL_TEXTURE_2D, texture);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, kTextureSize, kTextureSize, 0, GL_RGBA, GL_UNSIGNED_BYTE, GData);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    
    free(GData);
    GData = NULL;
    
    return texture;
}

/**
 *@brief    해당 인덱스에 맞는 IUFlowCoverRecord 클래스를 불러옵니다.
 *@param    index   불러올 인덱스
 *@return   인덱스에 해당되는 IUFlowCoverRecord 클래스
 */
- (IUFlowCoverRecord *)getTileAtIndex:(int)index
{
    NSNumber *num = [NSNumber numberWithInt:index];
    IUFlowCoverRecord *record = [_pCache objectForKey:num];
    if (record == nil) {
        GLuint texture = [self imageToTexture:[self getImage:index]];
        record = [[IUFlowCoverRecord alloc]initWithTexture:texture];
        [_pCache setObject:record forKey:num];
        
        [record release];
    }
    
    return record;
}

#pragma mark - Drawing Methods

/**
 *@brief    해당 인덱스의 이미지를 해당 위치에 그립니다.
 *@param    index   그릴 이미지의 인덱스
 *@param    offset  그릴 위치
 */
- (void)drawTile:(int)index atOffset:(double)offset{
    
    IUFlowCoverRecord *record = [self getTileAtIndex:index];
    GLfloat m[16];
    memset(m, 0, sizeof(m));
    m[10] = 1;
    m[15] = 1;
    m[0] = 1;
    m[5] = 1;
    double dTrans = offset * kSpreadImage;
    
    double dF = offset * kFlankSpread;
    if (dF < -kFlankSpread) {
        dF = -kFlankSpread;
    } else if( dF > kFlankSpread){
        dF = kFlankSpread;
    }
    m[3] = -dF;
    m[0] = 1 - fabs(dF);
    double dSc = 0.45 * (1 - fabs(dF));
    dTrans += dF * 1;
    
    glPushMatrix();
    glBindTexture(GL_TEXTURE_2D, record.texture);
    glTranslatef(dTrans, 0, 0);
    glScalef(dSc, dSc, 1.0);
    glMultMatrixf(m);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    if (_bEnableShadow) {
        glTranslatef(0, -2, 0);
        glScalef(1, -1, 1);
        glColor4f(0.5, 0.5, 0.5, 0.5);
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
        glColor4f(1, 1, 1, 1);
    }
    
    glPopMatrix();
}

/**
 *@brief    전체적으로 화면을 그립니다.
 */
- (void)draw{
    double dAspect = ((double)_nBackingWidth)/_nBackingHeight;
    
    glViewport(0, 0, _nBackingWidth, _nBackingHeight);
    glDisable(GL_DEPTH_TEST);
    
    glClearColor(0, 0, 0, 0);
    glVertexPointer(3, GL_FLOAT, 0, GVertices);
    glEnableClientState(GL_VERTEX_ARRAY);
    glTexCoordPointer(2, GL_SHORT, 0, GTextures);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    
    glEnable(GL_TEXTURE_2D);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_CONSTANT_ALPHA);
    glEnable(GL_BLEND);
    
    [EAGLContext setCurrentContext:_pContext];
    
    glBindFramebuffer(GL_FRAMEBUFFER_OES, _nViewFrameBuffer);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glScalef(1, dAspect, 1);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    
    int nLen = [self countOfTiles];
    int nMid = (int)floor(_dOffSet + 0.5);
    
    int nStartPos = nMid - kVisTiles;
    if (nStartPos < 0 && !_bEnableLoop) {
        nStartPos = 0;
    }
    
    int nEndPos = nMid + kVisTiles;
    if (nEndPos >= nLen && !_bEnableLoop) {
        nEndPos = nLen - 1;
    }
    
    
    for (int index = nStartPos; index < nMid; index++) {
        int now = index;
        if (_bEnableLoop) {
            if (now >= nLen) {
                while (now >= nLen) {
                    now -= nLen;
                }
            }else if(now < 0){
                while (now < 0) {
                    now += nLen;
                }
            }
        }
        [self drawTile:now atOffset:index - _dOffSet];
    }
    
    for (int index = nEndPos; index >= nMid; index--) {
        int now = index;
        if (_bEnableLoop) {
            if (now >= nLen) {
                while (now >= nLen) {
                    now -= nLen;
                }
            }else if(now < 0){
                while (now < 0) {
                    now += nLen;
                }
            }
        }
        [self drawTile:now atOffset:index - _dOffSet];
    }
    
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, _nViewRenderBuffer);
    [_pContext presentRenderbuffer:GL_RENDERBUFFER_OES];
}

#pragma mark - Animation Methods

/**
 *@brief    해당 시간의 애니메이션에 맞도록 화면을 그립니다.
 *@param    elapsed     해당 시간
 */
- (void)updateAnimationAtTime:(double)elapsed{
    int nMax = [self countOfTiles] - 1;
    
    if (elapsed > _dRunDelta) elapsed = _dRunDelta;
    double delta = fabs(_dStartSpeed) * elapsed - kFriction * elapsed * elapsed / 2;
    if (_dStartSpeed < 0) delta = -delta;
    _dOffSet = _dStartOff + delta;
    
    if (!_bEnableLoop) {
        if (_dOffSet > nMax) _dOffSet = nMax;
        if (_dOffSet < 0) _dOffSet = 0;
    }
    
    [self draw];
}

/**
 *@brief    애니메이션 완료후 화면 처리를 합니다.
 */
- (void)endAnimation{
    if (_pTimer) {
        int nMax = [self countOfTiles] - 1;
        _dOffSet = floor(_dOffSet + 0.5);
        
        if (_bEnableLoop) {
            while (_dOffSet > nMax) {
                _dOffSet -= (nMax+1);
            }
            while (_dOffSet < 0) {
                _dOffSet += (nMax+1);
            }
        }else{
            if (_dOffSet > nMax) _dOffSet = nMax;
            if (_dOffSet < 0) _dOffSet = 0;
        }
        
        [_pTimer invalidate];
        _pTimer = nil;
    }
}

/**
 *@brief    애니메이션 도중 화면 처리를 유도합니다.
 */
- (void)driveAnimation{
    double elapsed = CACurrentMediaTime() - _dStartTime;
    if (elapsed >= _dRunDelta) {
        [self endAnimation];
    }else{
        [self updateAnimationAtTime:elapsed];
    }
}

/**
 *@brief    애니메이션 시작 시 화면 처리와 애니메이션을 만듭니다.
 */
- (void)startAnimation:(double)speed{
    if (_pTimer) [self endAnimation];
    
    double dDelta = speed * speed / (kFriction * 2);
    if (speed < 0) dDelta = - dDelta;
    
    double dNearest = _dStartOff + dDelta;
    dNearest = floor(dNearest + 0.5);
    
    _dStartSpeed = sqrt(fabs(dNearest - _dStartOff) * kFriction * 2);
    if (dNearest < _dStartOff) _dStartSpeed = -_dStartSpeed;
    
    _dRunDelta = fabs(_dStartSpeed / kFriction);
    _dStartTime = CACurrentMediaTime();
    
    _pTimer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(driveAnimation) userInfo:nil repeats:YES];
}

#pragma mark - Touch Overriding Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    CGRect rect = self.bounds;
    UITouch *pTouch = [touches anyObject];
    CGPoint point = [pTouch locationInView:self];
    _dStartPos = (point.x / rect.size.width) * 10 - 5;
    _dStartOff = _dOffSet;
    
    _bTouchFlag = YES;
    _startTouchPoint = point;
    
    _dStartTime = CACurrentMediaTime();
    _dLastPos = _dStartPos;
    
    [self endAnimation];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    CGRect rect = self.bounds;
    UITouch *pTouch = [touches anyObject];
    CGPoint point = [pTouch locationInView:self];
    double dPos = (point.x / rect.size.width) * 10 - 5;
    
    if (_bTouchFlag) {
        rect.origin.x += (rect.size.width - kTextureSize)/2;
        rect.origin.y += (rect.size.height - kTextureSize)/2;
        rect.size.width = kTextureSize;
        rect.size.height = kTextureSize;
        
        if (CGRectContainsPoint(rect, point)) {
            [self selectAtIndex:(int)floor(_dOffSet + 0.01)];
        }
    }else{
        _dStartOff += (_dStartPos - dPos);
        _dOffSet = _dStartOff;
        
        double dTime = CACurrentMediaTime();
        double dSpeed = (_dLastPos - dPos)/(dTime - _dStartTime);
        if (dSpeed > kMaxSpeed) dSpeed = kMaxSpeed;
        if (dSpeed < -kMaxSpeed) dSpeed = -kMaxSpeed;
        
        [self startAnimation:dSpeed];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    CGRect rect = self.bounds;
    UITouch *pTouch = [touches anyObject];
    CGPoint point = [pTouch locationInView:self];
    double dPos = (point.x / rect.size.width) * 10 - 5;
    
    if (_bTouchFlag) {
        int nX = fabs(point.x - _startTouchPoint.x);
        int nY = fabs(point.y - _startTouchPoint.y);
        if ((nX < 3) && (nY < 3)) return;
        _bTouchFlag = NO;
    }
    
    int nMax = [self countOfTiles] - 1;
    
    _dOffSet = _dStartOff + (_dStartPos - dPos);
    if (!_bEnableLoop) {
        if (_dOffSet > nMax) _dOffSet = nMax;
        if (_dOffSet < 0) _dOffSet = 0;
    }
    [self draw];
    
    double dTime = CACurrentMediaTime();
    if (dTime - _dStartTime > 0.2) {
        _dStartTime = dTime;
        _dLastPos = dPos;
    }
}

#pragma mark - Customizing Property Methods

- (void)setEnableLoop:(BOOL)enableLoop{
    _bEnableLoop = enableLoop;
    [self draw];
}

- (BOOL)enableLoop{
    return _bEnableLoop;
}

- (void)setEnableShadow:(BOOL)enableShadow{
    _bEnableShadow = enableShadow;
    [self draw];
}

- (BOOL)enableShadow{
    return _bEnableShadow;
}

- (void)setSlotColor:(UIColor *)slotColor{
    _pSlotColor = slotColor;
    [_pCache clear];
    [self draw];
}

- (UIColor *)slotColor{
    return _pSlotColor;
}

- (void)setImageMode:(IUFlowCoverViewImageMode)imageMode{
    _eImageMode = imageMode;
    [_pCache clear];
    [self draw];
}

- (IUFlowCoverViewImageMode)imageMode{
    return _eImageMode;
}

#pragma mark - reload Methods

/**
 *@brief    데이터를 다시 불러와 화면을 다시 그립니다.
 */
- (void)reload{
    [_pCache clear];
    [self draw];
}

@end
