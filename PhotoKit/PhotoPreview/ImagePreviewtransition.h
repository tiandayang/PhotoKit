//
//  ImagePreviewtransition.h
//  PhotoPreview
//
//  Created by 田向阳 on 2016/12/8.
//  Copyright © 2016年 田向阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ImagePreviewtransition : NSObject<UIViewControllerAnimatedTransitioning>
- (instancetype)initWithClickView:(UIImageView*)imageView;
@end
