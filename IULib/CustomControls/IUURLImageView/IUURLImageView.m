//
//  IUURLImageView.m
//  IULib
//
//  Created by young-soo park on 12. 10. 5..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "IUURLImageView.h"

@implementation IUURLImageView

@synthesize defaultImage = _defaultImage;
@synthesize isLoadFinish = _isLoadFinished;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _isLoadFinished = NO;
        _indicatorView = [[UIActivityIndicatorView alloc]initWithFrame:self.frame];
        [self addSubview:_indicatorView];
        [_indicatorView setHidden:YES];
    }
    return self;
}

/**
 *@brief    웹에서 이미지를 불러옵니다.
 *@param    url 불러올 이미지의 url
 */
- (void)loadImageURL:(NSURL *)url
{
    _isLoadFinished = NO;
    [_indicatorView setHidden:NO];
    [_indicatorView startAnimating];
    [self setImage:_defaultImage];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [IUHtmlBlockConnector 
     conntectRequest:request 
     complate:^(NSData *data, NSURLResponse *response, NSError *error){
         [_indicatorView stopAnimating];
         [_indicatorView setHidden:YES];
         if (error) {
             NSLog(@"%@", [error description]);
         }
         else {
             _isLoadFinished = YES;
             _loadedImage = [[UIImage alloc]initWithData:data];
             [self setImage:_loadedImage];
         }
     }];
}

- (void)setDefaultImage:(UIImage *)defaultImage
{
    if (_defaultImage != defaultImage) {
        [_defaultImage release];
        if (defaultImage != nil) {
            _defaultImage = [defaultImage retain];
        }
    }
    if (!_isLoadFinished) {
        [self setImage:_defaultImage];
    }
}


@end
