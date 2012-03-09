/*
  IUSegmentedControl.m
  IULib

  Created by wimo wimo on 12. 2. 29..
  Copyright (c) 2012 __MyCompanyName__. All rights reserved.

 @author     cangel
 @since      version 0.1 
*/

#import "IUSegmentedControl.h"

#define kCornerRadius   10.0f ///<코너 곡률

/**
 *@category IUSegmentedControl(PrivateMethods)
 *@brief    IUSegmentedControl의 PrivateMethods
 *@author   Cangel
 */
@interface IUSegmentedControl (PrivateMethods)
- (BOOL)needCustomize;
- (void)setTintColorSetting;
- (void)setDisplay;
- (void)changeUISegmentFont:(UIView *)view Font:(UIFont *)font TextColor:(UIColor *)textColor;
- (bool)isSelectedSegment:(UIView *)view;
@end

@implementation IUSegmentedControl

#pragma mark -
#pragma mark UILifeCycle Funtions

/**< Nib에서 넘어왔을 때 기본적인 셋팅을 적용시켜준다. */
- (void)awakeFromNib {
    _pItems = [[NSMutableArray alloc]initWithCapacity:self.numberOfSegments];
    _pOnFont = ([self needCustomize])?[UIFont boldSystemFontOfSize:18.0f]:[UIFont systemFontOfSize:12];
    _pOffFont = ([self needCustomize])?[UIFont boldSystemFontOfSize:18.0f]:[UIFont systemFontOfSize:12];
    _pOnTextColor = [UIColor whiteColor];
    _pOffTextColor = [UIColor grayColor];
    
    for (int index = 0; index < self.numberOfSegments; index++) {
        ([self titleForSegmentAtIndex:index])?
        [_pItems addObject:[self titleForSegmentAtIndex:index]] : [_pItems addObject:[self imageForSegmentAtIndex:index]];
    }
    [self setNeedsDisplay];
}

/**< Item이 포함된 상태에서 Init되었을때 셋팅을 적용시켜준다. */
- (id)initWithItems:(NSArray *)items{
    self = [super initWithItems:items];
    if (self) {
        _pOnFont = [UIFont boldSystemFontOfSize:18.0f];
        _pOffFont = [UIFont boldSystemFontOfSize:18.0f];
        _pOnTextColor = [UIColor whiteColor];
        _pOffTextColor = [UIColor grayColor];
        self.selectedSegmentIndex = 0;
        [self setTintColorSetting];
        _pItems = [items mutableCopy];
    }
    return self;
}

- (void)dealloc{
    [_pItems removeAllObjects];
    [_pItems release];
    [_pOffTintColor release];
    [_pOnTintColor release];
    [_pOnTextColor release];
    [_pOffTextColor release];
    [_pOnFont release];
    [_pOffFont release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark private Functions

/**
 DrawRect커스터마이징이 필요한지 체크하여 준다.
 @returns YES = 필요(Bordered&Plain타입) NO = 불필요 (Bar&Bezeled타입)
 */
- (BOOL)needCustomize{
    return self.segmentedControlStyle == UISegmentedControlStyleBordered
        || self.segmentedControlStyle == UISegmentedControlStylePlain;
}

#pragma mark -
#pragma mark display Functions

/**
 Segment의 디자인을 적용시켜준다. 컨트롤의 타입에 따라서 DrawRect 또는 setTintColorSetting 함수로 분기된다.
 */
- (void)setDisplay{
    ([self needCustomize])?[self setNeedsDisplay]:[self setTintColorSetting];
}

/**
 모든 Segment의 다자인을 적용시킨다. (Bar또는 Bezeled 스타일에만 사용)
 */
- (void)setTintColorSetting {
    
    for (id subview in [self subviews]) {
        if ([self isSelectedSegment:subview]) {
            if (_pOnTintColor) [subview setTintColor:_pOnTintColor];
            [self changeUISegmentFont:subview Font:_pOnFont TextColor:_pOnTextColor];
        }else{
            if (_pOffTintColor) [subview setTintColor:_pOffTintColor];
            [self changeUISegmentFont:subview Font:_pOffFont TextColor:_pOffTextColor];
        }
    }
}

/**
 Segment의 Label을 찾아서 폰트와 텍스트 컬러를 적용시켜준다. 재귀함수로 동작한다.
 @param view Label인지 확인할 View
 @param font 적용할 font
 @param textColor 적용할 textColor
 */
- (void)changeUISegmentFont:(UIView *)view Font:(UIFont *)font TextColor:(UIColor *)textColor{
    NSString *pType = NSStringFromClass([view class]);
    if ([pType compare:@"UISegmentLabel" options:NSLiteralSearch] == NSOrderedSame) {
        UILabel *label = (UILabel *)view;
        if (font) [label setFont:font];
        if (textColor) [label setTextColor:textColor];
    }else{
        for (id subView in [view subviews]) {
            [self changeUISegmentFont:subView Font:font TextColor:textColor];
        }
    }
}

/**
 해당 Segment가 선택된 Segment인지 text 또는 image를 비교하여 체크하여 준다. 재귀함수로 동작한다.
 @param view 체크해야 될 View
 */
- (bool)isSelectedSegment:(UIView *)view
{
    NSString *pType = NSStringFromClass([view class]);
    if ([pType isEqualToString:@"UISegmentLabel"] && [self titleForSegmentAtIndex:self.selectedSegmentIndex]) {
        UILabel *label = (UILabel *)view;
        return [label.text isEqualToString:[self titleForSegmentAtIndex:self.selectedSegmentIndex]];
    }else if([pType isEqualToString:@"UIImageView"] && [self imageForSegmentAtIndex:self.selectedSegmentIndex]){
        UIImageView *imageView = (UIImageView *)view;
        return [imageView.image isEqual:[self imageForSegmentAtIndex:self.selectedSegmentIndex]];
    }else{
        BOOL result = NO;
        for (id subView in [view subviews]) {
            if ([self isSelectedSegment:subView])result = YES;
        }
        return result;
    }
}

#pragma mark -
#pragma mark Overriding Functions

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    int nItemIndex = floor(self.numberOfSegments * point.x / self.bounds.size.width);
    self.selectedSegmentIndex = nItemIndex;
    
    [self setDisplay];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)drawRect:(CGRect)rect{
    if (![self needCustomize]) {
        [super drawRect:rect];
        return;
    }
    
    for (UIView *subView in [self subviews]) {
        [subView removeFromSuperview];
    }
    
    //각 세그먼트들의 사이즈 구하기
    CGSize itemSize = CGSizeMake(round(rect.size.width / self.numberOfSegments), rect.size.height);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextSaveGState(context);
    
    //컨트롤러의 모서리를 둥글게 처리
    CGFloat minx = CGRectGetMinX(rect) + 1, midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect) ;
	CGFloat miny = CGRectGetMinY(rect) + 1, midy = CGRectGetMidY(rect) , maxy = CGRectGetMaxY(rect) ;
    
    CGContextMoveToPoint(context, minx - .5, midy - .5);
	CGContextAddArcToPoint(context, minx - .5, miny - .5, midx - .5, miny - .5, kCornerRadius);
	CGContextAddArcToPoint(context, maxx - .5, miny - .5, maxx - .5, midy - .5, kCornerRadius);
	CGContextAddArcToPoint(context, maxx - .5, maxy - .5, midx - .5, maxy - .5, kCornerRadius);
	CGContextAddArcToPoint(context, minx - .5, maxy - .5, minx - .5, midy - .5, kCornerRadius);
	CGContextClosePath(context);
	
	CGContextClip(context);
    
    //선택되지 않은 아이템의 배경에 그라데이션을 넣어준다.
    int red = 255, green = 255, blue = 255; // default white color
    if (_pOffTintColor != nil) {
        const CGFloat *components = CGColorGetComponents(_pOffTintColor.CGColor);
        size_t numberOfComponents = CGColorGetNumberOfComponents(_pOffTintColor.CGColor);
        
        if (numberOfComponents == 2) {
            red = green = blue = components[0] * 255;
        } else if (numberOfComponents == 4) {
            red   = components[0] * 255;
            green = components[1] * 255;
            blue  = components[2] * 255;
        }
    }
    CGFloat components[8] = { 
		red/255.0, green/255.0, blue/255.0, 1.0, 
		red * 0.8/255.0, green * 0.8/255.0, blue * 0.8/255.0, 1.0
	};
	CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, NULL, 2);
	CGContextDrawLinearGradient(context, gradient, CGPointZero, CGPointMake(0, rect.size.height), kCGGradientDrawsBeforeStartLocation);
	CFRelease(gradient);
    
    //선택된 아이템의 배경처리
    for (int index = 0; index < self.numberOfSegments; index++) {
		id item = [_pItems objectAtIndex:index];
		BOOL isLeftItem  = (index == 0);
		BOOL isRightItem = (index == self.numberOfSegments -1);
		
		CGRect itemBgRect = CGRectMake(index * itemSize.width, 
									   0.0f,
									   itemSize.width,
									   itemSize.height);
		
		if (index == self.selectedSegmentIndex) {
			
			//그라데이션은 위쪽 그라데이션, 아래쪽 그라데이션 두가지로 처리한다.
			
			CGContextSaveGState(context);
			CGContextClipToRect(context, itemBgRect);
			
			float factor  = 1.22f; // multiplier applied to the first color of the gradient to obtain the second
			float mfactor = 1.25f; // multiplier applied to the color of the first gradient to obtain the bottom gradient
			
			int red = 55, green = 111, blue = 214; // default blue color
			
			if (_pOnTintColor != nil) {
				const CGFloat *components = CGColorGetComponents(_pOnTintColor.CGColor);
				size_t numberOfComponents = CGColorGetNumberOfComponents(_pOnTintColor.CGColor);
				
				if (numberOfComponents == 2) {
					red = green = blue = components[0] * 255;
				} else if (numberOfComponents == 4) {
					red   = components[0] * 255;
					green = components[1] * 255;
					blue  = components[2] * 255;
				}
			}
			
			
			//위쪽 그라데이션
			
			CGFloat top_components[16] = { 
				red / 255.0f,         green / 255.0f,         blue/255.0f          , 1.0f,
				(red*mfactor)/255.0f, (green*mfactor)/255.0f, (blue*mfactor)/255.0f, 1.0f
			};
			
			CGFloat top_locations[2] = {
				0.0f, .75f
			};
			
			CGGradientRef top_gradient = CGGradientCreateWithColorComponents(colorSpace, top_components, top_locations, 2);
			CGContextDrawLinearGradient(context, 
										top_gradient, 
										itemBgRect.origin, 
										CGPointMake(itemBgRect.origin.x, 
													itemBgRect.size.height), 
										kCGGradientDrawsBeforeStartLocation);
			CFRelease(top_gradient);
			CGContextRestoreGState(context);
			
			
			// 아래쪽 그라데이션
			// 위치에 따라서 모서리를 곡면처리 해준다.
            
			CGRect bottomGradientRect = CGRectMake(itemBgRect.origin.x, 
												   itemBgRect.origin.y + round(itemBgRect.size.height / 2), 
												   itemBgRect.size.width, 
												   round(itemBgRect.size.height / 2));
			
			CGFloat gradient_minx = CGRectGetMinX(bottomGradientRect) + 1;
			CGFloat gradient_midx = CGRectGetMidX(bottomGradientRect);
			CGFloat gradient_maxx = CGRectGetMaxX(bottomGradientRect);
			CGFloat gradient_miny = CGRectGetMinY(bottomGradientRect) + 1;
			CGFloat gradient_midy = CGRectGetMidY(bottomGradientRect);
			CGFloat gradient_maxy = CGRectGetMaxY(bottomGradientRect);
			
			
			CGContextSaveGState(context);
			if (isLeftItem) {
				CGContextMoveToPoint(context, gradient_minx - .5f, gradient_midy - .5f);
			} else {
				CGContextMoveToPoint(context, gradient_minx - .5f, gradient_miny - .5f);
			}
			
			CGContextAddArcToPoint(context, gradient_minx - .5f, gradient_miny - .5f, gradient_midx - .5f, gradient_miny - .5f, kCornerRadius);
			
			if (isRightItem) {
				CGContextAddArcToPoint(context, gradient_maxx - .5f, gradient_miny - .5f, gradient_maxx - .5f, gradient_midy - .5f, kCornerRadius);
				CGContextAddArcToPoint(context, gradient_maxx - .5f, gradient_maxy - .5f, gradient_midx - .5f, gradient_maxy - .5f, kCornerRadius);
			} else {
				CGContextAddLineToPoint(context, gradient_maxx, gradient_miny);
				CGContextAddLineToPoint(context, gradient_maxx, gradient_maxy);
			}
			
			if (isLeftItem) {
				CGContextAddArcToPoint(context, gradient_minx - .5f, gradient_maxy - .5f, gradient_minx - .5f, gradient_midy - .5f, kCornerRadius);
			} else {
				CGContextAddLineToPoint(context, gradient_minx, gradient_maxy);
			}
			
			CGContextClosePath(context);
			
			
			CGContextClip(context);
			CGFloat bottom_components[16] = {
				(red*factor)        /255.0f, (green*factor)        /255.0f, (blue*factor)/255.0f,         1.0f,
				(red*factor*mfactor)/255.0f, (green*factor*mfactor)/255.0f, (blue*factor*mfactor)/255.0f, 1.0f
			};
			
			CGFloat bottom_locations[2] = {
				0.0f, 1.0f
			};
			
			CGGradientRef bottom_gradient = CGGradientCreateWithColorComponents(colorSpace, bottom_components, bottom_locations, 2);
			CGContextDrawLinearGradient(context, 
										bottom_gradient, 
										bottomGradientRect.origin, 
										CGPointMake(bottomGradientRect.origin.x, 
													bottomGradientRect.origin.y + bottomGradientRect.size.height), 
										kCGGradientDrawsBeforeStartLocation);
			CFRelease(bottom_gradient);
			CGContextRestoreGState(context);
			
			
			
			//내부 그림자.
			
			int blendMode = kCGBlendModeDarken;
			
			//오른쪽과 왼쪽에 그림자 처리를 해준다. 
			CGContextSaveGState(context);
			CGContextSetBlendMode(context, blendMode);
			CGContextClipToRect(context, itemBgRect);
			
			CGFloat inner_shadow_components[16] = {
				0.0f, 0.0f, 0.0f, isLeftItem ? 0.0f : .25f,
				0.0f, 0.0f, 0.0f, 0.0f,
				0.0f, 0.0f, 0.0f, 0.0f,
				0.0f, 0.0f, 0.0f, isRightItem ? 0.0f : .25f
			};
			
			
			CGFloat locations[4] = {
				0.0f, .05f, .95f, 1.0f
			};
			CGGradientRef inner_shadow_gradient = CGGradientCreateWithColorComponents(colorSpace, inner_shadow_components, locations, 4);
			CGContextDrawLinearGradient(context, 
										inner_shadow_gradient, 
										itemBgRect.origin, 
										CGPointMake(itemBgRect.origin.x + itemBgRect.size.width, 
													itemBgRect.origin.y), 
										kCGGradientDrawsAfterEndLocation);
			CFRelease(inner_shadow_gradient);
			CGContextRestoreGState(context);
			
			//위쪽 그림자 처리 
			CGContextSaveGState(context);
			CGContextSetBlendMode(context, blendMode);
			CGContextClipToRect(context, itemBgRect);
			CGFloat top_inner_shadow_components[8] = { 
				0.0f, 0.0f, 0.0f, 0.25f,
				0.0f, 0.0f, 0.0f, 0.0f
			};
			CGFloat top_inner_shadow_locations[2] = {
				0.0f, .10f
			};
			CGGradientRef top_inner_shadow_gradient = CGGradientCreateWithColorComponents(colorSpace, top_inner_shadow_components, top_inner_shadow_locations, 2);
			CGContextDrawLinearGradient(context, 
										top_inner_shadow_gradient, 
										itemBgRect.origin, 
										CGPointMake(itemBgRect.origin.x, 
													itemBgRect.size.height), 
										kCGGradientDrawsAfterEndLocation);
			CFRelease(top_inner_shadow_gradient);
			CGContextRestoreGState(context);
			
		}
		
		if ([item isKindOfClass:[UIImage class]]) {
			
			CGImageRef imageRef = [(UIImage *)item CGImage];
			
			CGRect imageRect = CGRectMake(round(index * itemSize.width + (itemSize.width - CGImageGetWidth(imageRef)) / 2), 
										  round((itemSize.height - CGImageGetHeight(imageRef)) / 2),
										  CGImageGetWidth(imageRef),
										  CGImageGetHeight(imageRef));
			
			
			if (index == self.selectedSegmentIndex) {
				
				CGContextSaveGState(context);
				CGContextTranslateCTM(context, 0, rect.size.height);  
				CGContextScaleCTM(context, 1.0, -1.0);  
				
				CGContextRestoreGState(context);
				
				CGContextSaveGState(context);
				CGContextTranslateCTM(context, 0, rect.size.height);  
				CGContextScaleCTM(context, 1.0, -1.0);  
				
				CGContextClipToMask(context, imageRect, imageRef);
				CGContextSetFillColorWithColor(context, [_pOnTextColor CGColor]);
				
				CGContextFillRect(context, imageRect);
				CGContextRestoreGState(context);
			} 
			else {
				
				//그림자 효과
				CGContextSaveGState(context);
				CGContextTranslateCTM(context, 0, itemBgRect.size.height);  
				CGContextScaleCTM(context, 1.0, -1.0);  
				
				CGContextClipToMask(context, CGRectOffset(imageRect, 0, -1), imageRef);
				CGContextSetFillColorWithColor(context, [_pOffTintColor CGColor]);
				CGContextFillRect(context, CGRectOffset(imageRect, 0, -1));
				CGContextRestoreGState(context);
				
				//마스크 효과
				CGContextSaveGState(context);
				CGContextTranslateCTM(context, 0, itemBgRect.size.height);  
				CGContextScaleCTM(context, 1.0, -1.0);  
				
				CGContextClipToMask(context, imageRect, imageRef);
				CGContextSetFillColorWithColor(context, [_pOffTextColor CGColor]);
				CGContextFillRect(context, imageRect);
				CGContextRestoreGState(context);
			}
			
		}
		else if ([item isKindOfClass:[NSString class]]) {
			
			NSString *string = (NSString *)[_pItems objectAtIndex:index];
            NSLog(@"string : %@", string);
			CGSize stringSize = (index == self.selectedSegmentIndex)?
                                [string sizeWithFont:_pOnFont]:[string sizeWithFont:_pOffFont];
			CGRect stringRect = CGRectMake(index * itemSize.width + (itemSize.width - stringSize.width) / 2, 
										   (itemSize.height - stringSize.height) / 2,// + kTopPadding,
										   stringSize.width,
										   stringSize.height);
			
			if (self.selectedSegmentIndex == index) {
				[[UIColor colorWithWhite:0.0f alpha:.2f] setFill];
				[string drawInRect:CGRectOffset(stringRect, 0.0f, -1.0f) withFont:_pOnFont];
				[_pOnTextColor setFill];	
				[_pOnTextColor setStroke];	
				[string drawInRect:stringRect withFont:_pOnFont];
			} else {
				[[UIColor whiteColor] setFill];			
				[string drawInRect:CGRectOffset(stringRect, 0.0f, 1.0f) withFont:_pOffFont];
				[_pOffTextColor setFill];
				[string drawInRect:stringRect withFont:_pOffFont];
			}
		}
		
		// 아이템들의 구분선
		if (index > 0 && index - 1 != self.selectedSegmentIndex && index != self.selectedSegmentIndex) {
			CGContextSaveGState(context);
			
			CGContextMoveToPoint(context, itemBgRect.origin.x + .5, itemBgRect.origin.y);
			CGContextAddLineToPoint(context, itemBgRect.origin.x + .5, itemBgRect.size.height);
			
			CGContextSetLineWidth(context, .5f);
			CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:120/255.0 alpha:1.0].CGColor);
			CGContextStrokePath(context);
			
			CGContextRestoreGState(context);
		}
		
	}
	
	CGContextRestoreGState(context);
    
    if (self.segmentedControlStyle ==  UISegmentedControlStyleBordered) {
		CGContextMoveToPoint(context, minx - .5, midy - .5);
		CGContextAddArcToPoint(context, minx - .5, miny - .5, midx - .5, miny - .5, kCornerRadius);
		CGContextAddArcToPoint(context, maxx - .5, miny - .5, maxx - .5, midy - .5, kCornerRadius);
		CGContextAddArcToPoint(context, maxx - .5, maxy - .5, midx - .5, maxy - .5, kCornerRadius);
		CGContextAddArcToPoint(context, minx - .5, maxy - .5, minx - .5, midy - .5, kCornerRadius);
		CGContextClosePath(context);
		
		CGContextSetStrokeColorWithColor(context,[UIColor blackColor].CGColor);
		CGContextSetLineWidth(context, 1.0f);
		CGContextStrokePath(context);
	} else {
		CGContextSaveGState(context);
		
		CGRect bottomHalfRect = CGRectMake(0, 
										   rect.size.height - kCornerRadius + 7,
										   rect.size.width,
										   kCornerRadius);
		CGContextClearRect(context, CGRectMake(0, 
										 rect.size.height - 1,
										 rect.size.width,
										 1));
		CGContextClipToRect(context, bottomHalfRect);
		
		CGContextMoveToPoint(context, minx + .5, midy - .5);
		CGContextAddArcToPoint(context, minx + .5, miny - .5, midx - .5, miny - .5, kCornerRadius);
		CGContextAddArcToPoint(context, maxx - .5, miny - .5, maxx - .5, midy - .5, kCornerRadius);
		CGContextAddArcToPoint(context, maxx - .5, maxy - .5, midx - .5, maxy - .5, kCornerRadius);
		CGContextAddArcToPoint(context, minx + .5, maxy - .5, minx - .5, midy - .5, kCornerRadius);
		CGContextClosePath(context);
		
		CGContextSetBlendMode(context, kCGBlendModeLighten);
		CGContextSetStrokeColorWithColor(context,[UIColor colorWithWhite:255/255.0 alpha:1.0].CGColor);
		CGContextSetLineWidth(context, .5f);
		CGContextStrokePath(context);
		
		CGContextRestoreGState(context);
		midy--, maxy--;
		CGContextMoveToPoint(context, minx - .5, midy - .5);
		CGContextAddArcToPoint(context, minx - .5, miny - .5, midx - .5, miny - .5, kCornerRadius);
		CGContextAddArcToPoint(context, maxx - .5, miny - .5, maxx - .5, midy - .5, kCornerRadius);
		CGContextAddArcToPoint(context, maxx - .5, maxy - .5, midx - .5, maxy - .5, kCornerRadius);
		CGContextAddArcToPoint(context, minx - .5, maxy - .5, minx - .5, midy - .5, kCornerRadius);
		CGContextClosePath(context);
		
		CGContextSetBlendMode(context, kCGBlendModeMultiply);
		CGContextSetStrokeColorWithColor(context,[UIColor colorWithWhite:30/255.0 alpha:.9].CGColor);
		CGContextSetLineWidth(context, .5f);
		CGContextStrokePath(context);
	}
    
	
	CFRelease(colorSpace);

}



#pragma mark -
#pragma mark Property Functions

- (void)setOnTintColor:(UIColor *)onTintColor{
    _pOnTintColor = [onTintColor retain];
    [self setDisplay];
}

- (UIColor *)onTintColor{
    return _pOnTintColor;
}

- (void)setOffTintColor:(UIColor *)offTintColor{
    _pOffTintColor = [offTintColor retain];
    [self setDisplay];
}

- (UIColor *)offTintColor{
    return _pOffTintColor;
}

- (void)setOnFont:(UIFont *)onFont{
    _pOnFont = [onFont retain];
    [self setDisplay];
}

- (UIFont *)onFont{
    return _pOnFont;
}

- (void)setOffFont:(UIFont *)offFont{
    _pOffFont = [offFont retain];
    [self setDisplay];
}

- (UIFont *)offFont{
    return _pOffFont;
}

- (void)setOnTextColor:(UIColor *)onTextColor{
    _pOnTextColor = [onTextColor retain];
    [self setDisplay];
}

- (UIColor *)onTextColor{
    return _pOnTextColor;
}

- (void)setOffTextColor:(UIColor *)offTextColor{
    _pOffTextColor = [offTextColor retain];
    [self setDisplay];
}

- (UIColor *)offTextColor{
    return _pOffTextColor;
}

@end
