//
//  IUURLImageView.h
//  IULib
//
//  Created by young-soo park on 12. 10. 5..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IUHtmlBlockConnector.h"

@interface IUURLImageView : UIImageView{
    BOOL                            _isLoadFinished;
    UIActivityIndicatorView         *_indicatorView;
    
    UIImage                         *_defaultImage;
    UIImage                         *_loadedImage;
}

@property   (nonatomic, retain)     UIImage         *defaultImage;          ///< 비 로딩 시 화면에 출력되는 이미지
@property   (nonatomic, readonly)   BOOL            isLoadFinish;           ///< 이미지 로딩 완료 되었는 지 체크.

- (void)loadImageURL:(NSURL *)url;

@end
