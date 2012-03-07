//
//  IURangeSliderControl.m
//  IULib
//
//  Created by wimo wimo on 12. 3. 2..
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IURangeSliderControl.h"

@interface IURangeSliderControl (PrivateMethods)

-(float)xForValue:(float)value;
-(float)valueForX:(float)x;

@end

@implementation IURangeSliderControl

@synthesize minimumValue            =   _fMinValue;
@synthesize maximumValue            =   _fMaxValue;
@synthesize minimumRange            =   _fMinRange;
@synthesize selectedMinimumValue    =   _fSelMinValue;
@synthesize selectedMaximumValue    =   _fSelMaxValue;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeControl];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initializeControl];
    }
    return self;
}

/**
 *@brief    컨트롤 기본셋팅
 */
- (void)initializeControl{
    _bMinThumbOn = NO;
    _bMaxThumbOn = NO;
    _fPadding = 20.0f;
    
    _fMinValue = 0;
    _fMaxValue = 1;
    _fMinRange = 0.1;
    _fSelMinValue = 0;
    _fSelMaxValue = 1;
    
    UIImage *pTrackBackGroundImage  = [[UIImage imageNamed:@"bar-background.png"]
                                       stretchableImageWithLeftCapWidth:6.0f topCapHeight:0];
    UIImage *pTrackImage            = [[UIImage imageNamed:@"bar-highlight.png"]
                                       stretchableImageWithLeftCapWidth:6.0f topCapHeight:0.0f];
    
    
    _pTrackBackGround   = [[UIImageView alloc]initWithImage:pTrackBackGroundImage];
    [_pTrackBackGround setFrame:CGRectMake(_fPadding, self.frame.size.height/2-(pTrackBackGroundImage.size.height/2), 
                                           self.frame.size.width - (_fPadding * 2), pTrackBackGroundImage.size.height)];
    _pTrack             = [[UIImageView alloc]initWithImage:pTrackImage];
    [_pTrack            setFrame:CGRectMake([self xForValue:_fSelMinValue], self.frame.size.height/2-(pTrackImage.size.height/2), 
                                            [self xForValue:_fSelMaxValue] - [self xForValue:_fSelMinValue], pTrackImage.size.height)];
    
    [self addSubview:_pTrackBackGround];
    [self addSubview:_pTrack];
    
    _pMinThumb          = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"handle.png"] 
                                           highlightedImage:[UIImage imageNamed:@"handle-hover.png"]];
    _pMaxThumb          = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"handle.png"] 
                                           highlightedImage:[UIImage imageNamed:@"handle-hover.png"]];
    
    [_pMinThumb setCenter:CGPointMake([self xForValue:_fSelMinValue], self.frame.size.height/2)];
    [_pMaxThumb setCenter:CGPointMake([self xForValue:_fSelMaxValue], self.frame.size.height/2)];
    
    [self addSubview:_pMinThumb];
    [self addSubview:_pMaxThumb];
}

- (void)dealloc{
    [_pMinThumb         release];
    [_pMaxThumb         release];
    [_pTrack            release];
    [_pTrackBackGround  release];
    
    for (UIView *view in [self subviews]) {
        [view removeFromSuperview];
    }
    
    [super dealloc];
}

#pragma mark -
#pragma mark private Methods

/**
 *@brief    value값에 따른 x좌표를 리턴합니다.
 *@param    value 해당되는 값
 *@return   x좌표
 *@author   Cangel
 */
- (float)xForValue:(float)value{
    return ( (value - _fMinValue) /  (_fMaxValue - _fMinValue) ) * (self.frame.size.width - (_fPadding * 2)) + _fPadding;
}

/**
 *@brief    x좌표에 따른 value값을 리턴합니다.
 *@param    x x좌표값
 *@return   해당되는 value값
 *@author   Cangel
 */
- (float)valueForX:(float)x{
    return ( ( (x - _fPadding) * (_fMaxValue - _fMinValue) ) / (self.frame.size.width - (_fPadding * 2)) ) - _fMinValue;
}

#pragma mark -
#pragma mark touch overriding Methods
- (BOOL) beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchPoint = [touch locationInView:self];
    if(CGRectContainsPoint(_pMaxThumb.frame, touchPoint)){
        _bMaxThumbOn = YES;
        [_pMaxThumb setHighlighted:YES];
    }else if(CGRectContainsPoint(_pMinThumb.frame, touchPoint)){
        _bMinThumbOn = YES;
        [_pMinThumb setHighlighted:YES];
    }
    
    return YES;
}

- (void) endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    _bMaxThumbOn = NO;
    [_pMaxThumb setHighlighted:NO];
    _bMinThumbOn = NO;
    [_pMinThumb setHighlighted:NO];
}

- (BOOL) continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    if (!_bMinThumbOn && !_bMaxThumbOn) {
        return YES;
    }
    
    CGPoint touchPoint = [touch locationInView:self];
    if (_bMaxThumbOn) {
        _pMaxThumb.center = CGPointMake(MIN([self xForValue:_fMaxValue], 
                                            MAX(touchPoint.x, [self xForValue:_fSelMinValue+_fMinRange])), 
                                        self.frame.size.height/2);
        _fSelMaxValue = [self valueForX:_pMaxThumb.center.x];
    }else if(_bMinThumbOn){
        _pMinThumb.center = CGPointMake(MAX([self xForValue:_fMinValue], 
                                            MIN(touchPoint.x, [self xForValue:_fSelMaxValue-_fMinRange])), 
                                        self.frame.size.height/2);
        _fSelMinValue = [self valueForX:_pMinThumb.center.x];
    }
    //[self setNeedsDisplay];
    [_pTrack            setFrame:CGRectMake([self xForValue:_fSelMinValue], self.frame.size.height/2-(_pTrack.frame.size.height/2), 
                                            [self xForValue:_fSelMaxValue] - [self xForValue:_fSelMinValue], _pTrack.frame.size.height)];
    [super sendActionsForControlEvents:UIControlEventValueChanged];
    
    return YES;
}

#pragma mark -
#pragma mark customizing Property

- (void)setMaximumValue:(float)maximumValue{
    _fMaxValue = maximumValue;
    _fSelMaxValue = MIN(_fSelMaxValue, _fMaxValue);
    [_pMaxThumb setCenter:CGPointMake([self xForValue:_fSelMaxValue], self.frame.size.height/2)];
}

- (float)maximumValue{
    return _fMaxValue;
}

- (void)setMinimumValue:(float)minimumValue{
    _fMinValue = minimumValue;
    _fSelMinValue = MAX(_fSelMinValue, _fMinValue);
    [_pMinThumb setCenter:CGPointMake([self xForValue:_fSelMinValue], self.frame.size.height/2)];
}

- (float)minimumValue{
    return _fMinValue;
}

- (void)setSelectedMaximumValue:(float)selectedMaximumValue{
    _fSelMaxValue = MIN(_fMaxValue, selectedMaximumValue);
    [_pMaxThumb setCenter:CGPointMake([self xForValue:_fSelMaxValue], self.frame.size.height/2)];
}

- (float)selectedMaximumValue{
    return _fSelMaxValue;
}

- (void)setSelectedMinimumValue:(float)selectedMinimumValue{
    _fSelMinValue = MAX(_fMinValue, selectedMinimumValue);
    [_pMinThumb setCenter:CGPointMake([self xForValue:_fSelMinValue], self.frame.size.height/2)];
}

- (float)selectedMinimumValue{
    return _fSelMinValue;
}

- (void)setMaximumTrackImage:(UIImage *)maximumTrackImage{
    [_pTrack setImage:maximumTrackImage];
    [_pTrack setFrame:CGRectMake([self xForValue:_fSelMinValue], self.frame.size.height/2-(maximumTrackImage.size.height/2), 
                                [self xForValue:_fSelMaxValue] - [self xForValue:_fSelMinValue], maximumTrackImage.size.height)];
}

- (UIImage *)maximumTrackImage{
    return _pTrack.image;
}

- (void)setMinimumTrackImage:(UIImage *)minimumTrackImage{
    [_pTrackBackGround setImage:minimumTrackImage];
    [_pTrackBackGround setFrame:CGRectMake(_fPadding, self.frame.size.height/2-(minimumTrackImage.size.height/2), 
                                           self.frame.size.width - (_fPadding * 2), minimumTrackImage.size.height)];
}

- (UIImage *)minimumTrackImage{
    return _pTrackBackGround.image;
}

- (void)setThumbImage:(UIImage *)thumbImage{
    [_pMinThumb setImage:thumbImage];
    [_pMaxThumb setImage:thumbImage];
    [_pMinThumb setCenter:CGPointMake([self xForValue:_fSelMinValue], self.frame.size.height/2)];
    [_pMaxThumb setCenter:CGPointMake([self xForValue:_fSelMaxValue], self.frame.size.height/2)];
}

- (UIImage *)thumbImage{
    return _pMinThumb.image;
}

/**
 *@brief    각 상태에 대한 버튼의 이미지를 셋팅합니다.
 *@param    image 버튼이미지
 *@param    state 해당 상태(Normal, Highlighted 만 적용됨)
 *@author   Cangel
 */
- (void)setThumbImage:(UIImage *)image forState:(UIControlState)state{
    switch (state) {
        case UIControlStateNormal:
            [_pMinThumb setImage:image];
            [_pMaxThumb setImage:image];
            break;
        case UIControlStateHighlighted:
            [_pMinThumb setHighlightedImage:image];
            [_pMaxThumb setHighlightedImage:image];
            break;
    }
    [_pMinThumb setCenter:CGPointMake([self xForValue:_fSelMinValue], self.frame.size.height/2)];
    [_pMaxThumb setCenter:CGPointMake([self xForValue:_fSelMaxValue], self.frame.size.height/2)];
}

/**
 *@brief    각 상태에 대한 기본 바의 이미지를 셋팅합니다.
 *@param    image 바이미지
 *@param    state 해당 상태(Normal, Highlighted 만 적용됨)
 *@author   Cangel
 */
- (void)setMinimumTrackImage:(UIImage *)image forState:(UIControlState)state{
    switch (state) {
        case UIControlStateNormal:
            [_pTrackBackGround setImage:image];
            [_pTrackBackGround setFrame:CGRectMake(_fPadding, self.frame.size.height/2-(image.size.height/2), 
                                                   self.frame.size.width - (_fPadding * 2), image.size.height)];
            break;
        case UIControlStateHighlighted:
            [_pTrackBackGround setHighlightedImage:image];
            break;
    }
}

/**
 *@brief    각 상태에 대한 바의 선택영역 이미지를 셋팅합니다.
 *@param    image 바 선택영역이미지
 *@param    state 해당 상태(Normal, Highlighted 만 적용됨)
 *@author   Cangel
 */
- (void)setMaximumTrackImage:(UIImage *)image forState:(UIControlState)state{
    switch (state) {
        case UIControlStateNormal:
            [_pTrack setImage:image];
            [_pTrack setFrame:CGRectMake(_fPadding, self.frame.size.height/2-(image.size.height/2), 
                                         self.frame.size.width - (_fPadding * 2), image.size.height)];
            break;
        case UIControlStateHighlighted:
            [_pTrack setHighlightedImage:image];
            break;
    }
}

- (void)setEnabled:(BOOL)enabled{
    for (UIView *view in [self subviews]) {
        [view setAlpha:(enabled)?1.0f:0.5f];
    }
    [super setEnabled:enabled];
}

@end
